# Sistema de Alquiler de Vehículos

Contexto persistente del proyecto. Leer este archivo al empezar cualquier sesión de trabajo nueva.

## 0. Metodología de trabajo (trabajo integrador)

Este proyecto sigue un flujo de 6 fases documentado en **`docs/00-roadmap.md`** (leer ese archivo
para ver el estado de avance actualizado): Épicas y Stories → Requerimientos → Diagramas UML →
Base de datos → Mockup/Prototipo → Programa funcional. Cada fase tiene su entregable dentro de
`docs/`. **No se salta de fase**: no se escribe código de negocio hasta llegar a la Fase 6, salvo
el scaffolding técnico ya creado (ver sección 5).

**Idiomas**: la documentación de las fases 1-5 se escribe en **español**. El código de la Fase 6
(clases, variables, métodos, comentarios) se escribe en **inglés**. Esto es una decisión tomada
después de armar el scaffolding inicial, por eso el paquete Java actual (`com.alquilervehiculos`)
todavía tiene nombres en español — se renombra a inglés recién al arrancar la Fase 6, para no
duplicar trabajo mientras estamos en fases de documentación.

## 1. Descripción del proyecto

Una empresa de alquiler de vehículos necesita un sistema para controlar vehículos, clientes,
reservas y alquileres.

**Nivel de desarrollo objetivo: junior.** Todo el código, las decisiones de arquitectura y las
convenciones de este proyecto deben priorizar la simplicidad y la legibilidad por sobre patrones
avanzados, abstracciones prematuras o "magia" innecesaria. Ante la duda entre una solución simple
y una "más profesional" pero compleja, se elige la simple. Se puede refactorizar más adelante si
hace falta.

## 2. MVP

- Registro de vehículos.
- Registro de clientes.
- Reservas (un cliente reserva un vehículo para un rango de fechas), creadas por un empleado o por
  el propio cliente a través de un formulario público (sin login, con datos básicos obligatorios).
- Gestión de alquileres (el alquiler efectivo cuando el cliente retira el vehículo).

Fuera de alcance del MVP (no implementar todavía): pagos/facturación, autenticación/login,
roles/permisos, notificaciones, reportes, multi-sucursal.

## 3. Entidades principales (borrador inicial)

> Este es un primer borrador para arrancar. El modelo definitivo se define recién en la **Fase 4
> (Base de datos)**, en `docs/04-base-de-datos/`, en base a lo que salga de los Requerimientos
> (Fase 2) y los diagramas UML (Fase 3). Los nombres de campos acá están en español porque son
> parte de la documentación; en el código (Fase 6) se traducen al inglés (ver equivalencias en la
> sección 6).

- **Vehiculo**: id, patente, marca, modelo, anio, tipo, estado (DISPONIBLE / ALQUILADO /
  MANTENIMIENTO), precioPorDia.
- **Cliente**: id, nombre, apellido, documento (DNI), email, telefono.
- **Reserva**: id, cliente (FK), vehiculo (FK), fechaInicio, fechaFin, estado (PENDIENTE /
  CONFIRMADA / CANCELADA).
- **Alquiler**: id, reserva (FK, opcional), cliente (FK), vehiculo (FK), fechaInicioReal,
  fechaFinReal, estado (ACTIVO / FINALIZADO), montoTotal.

Relaciones: un Cliente tiene muchas Reservas; un Vehiculo tiene muchas Reservas; una Reserva puede
derivar en un Alquiler cuando el cliente retira el vehículo.

> **Nota**: no hay entidad de autenticación (ni Empleado ni Cliente tienen usuario/contraseña) —
> decisión confirmada de no manejar seguridad en el MVP. Cuando un cliente reserva por el
> formulario público (épica E5 en `docs/01-epicas-historias-usuario.md`), si ya existe un Cliente
> con ese documento se reutiliza el registro; si no, se crea uno nuevo.

## 4. Stack elegido y por qué

| Decisión | Elección | Por qué |
|---|---|---|
| Lenguaje | **Java 17** | Pedido explícito del usuario (ya lo conoce). |
| Framework backend | **Spring Boot 3 (Web + Data JPA + Validation)** | Es el stack estándar de facto para un junior de Java: enorme cantidad de tutoriales, convención sobre configuración, comunidad grande. Evita reinventar cosas (servidor web, mapeo objeto-relacional, validaciones) que un junior no debería construir a mano. |
| Build tool | **Maven** | Más común que Gradle en material de aprendizaje para juniors; configuración declarativa en XML, sin scripting. |
| Base de datos | **PostgreSQL** | Elegido por el usuario. Motor "de verdad", gratuito, similar a lo que se usa en producción. |
| Persistencia | **Spring Data JPA / Hibernate**, con `ddl-auto=update` en desarrollo | Evita escribir SQL a mano para CRUDs básicos. `ddl-auto=update` es una simplificación válida para el MVP; cuando el modelo esté estable conviene migrar a Flyway (fuera del MVP). |
| Tipo de app | **API REST** en el back-office de Empleado; el flujo de reserva del Cliente (sin login) necesita una **UI mínima** de formulario | El back-office de Empleado se prueba por API (Postman/curl) sin UI propia. El formulario público de reserva del Cliente es la excepción — su UI mínima se diseña en la Fase 5 (Mockup/Prototipo), sin decidir todavía con qué tecnología se construye. |
| Mapeo objeto-JSON | Se exponen las **entidades directamente** como respuesta JSON (sin DTOs) en el MVP | Simplificación consciente para no sumar una capa extra al principio. Documentado como deuda técnica a resolver si el proyecto crece (ver sección 7). |
| Getters/Setters | **Escritos a mano, sin Lombok** | Lombok genera código con anotaciones ("magia"); para un nivel junior es mejor ver explícitamente los getters/setters y entender qué hace cada clase. Se puede introducir Lombok más adelante si se vuelve tedioso. |

## 5. Estructura de carpetas

Arquitectura en capas clásica (Controller → Service → Repository → Model), la más simple y
estándar en Spring Boot:

```
sistema-alquiler-vehiculos/
├── pom.xml
├── CLAUDE.md
├── .gitignore
└── src/
    ├── main/
    │   ├── java/com/alquilervehiculos/
    │   │   ├── SistemaAlquilerVehiculosApplication.java   (clase main, @SpringBootApplication)
    │   │   ├── controller/     (endpoints REST, reciben HTTP, delegan al service)
    │   │   ├── service/        (lógica de negocio: reglas de reservas, disponibilidad, etc.)
    │   │   ├── repository/     (interfaces JpaRepository, acceso a datos)
    │   │   └── model/          (entidades JPA: Vehiculo, Cliente, Reserva, Alquiler)
    │   └── resources/
    │       └── application.properties   (config; application.properties.example es la plantilla)
    └── test/
        └── java/com/alquilervehiculos/  (tests, se completan en la etapa de testing)
```

Reglas simples:
- Una clase por archivo, nombre de archivo == nombre de clase.
- No se crean sub-paquetes nuevos (ej. `controller/impl`, `service/interfaces`) salvo que haga
  falta de verdad. Nada de interfaces "por las dudas" para una sola implementación.
- Si una clase de `service` empieza a superar ~150-200 líneas o a mezclar responsabilidades muy
  distintas, ahí sí se evalúa dividirla — no antes.

## 6. Convenciones de código

> Estas convenciones aplican recién en la **Fase 6**. Se documentan ahora para no tener que
> redecidirlas más adelante.

**Equivalencias español (documentación) → inglés (código)**, para que al traducir a código no haya
ambigüedad:

| Documentación (ES) | Código (EN) |
|---|---|
| Vehículo | `Vehicle` |
| Cliente | `Customer` |
| Reserva | `Reservation` |
| Alquiler | `Rental` |
| patente | `licensePlate` |
| marca | `brand` |
| modelo | `model` |
| año | `year` |
| tipo | `type` |
| estado | `status` |
| precioPorDia | `pricePerDay` |
| nombre / apellido | `firstName` / `lastName` |
| documento (DNI) | `documentNumber` |
| fechaInicio / fechaFin | `startDate` / `endDate` |
| montoTotal | `totalAmount` |
| Disponible / Alquilado / Mantenimiento | `AVAILABLE` / `RENTED` / `MAINTENANCE` |
| Pendiente / Confirmada / Cancelada | `PENDING` / `CONFIRMED` / `CANCELLED` |

- **Clases**: `PascalCase`, en inglés (ej. `VehicleController`, `ReservationService`).
- **Métodos y variables**: `camelCase`, en inglés (ej. `findVehicleById`).
- **Constantes**: `UPPER_SNAKE_CASE`.
- **Paquetes**: todo minúscula, sin guiones ni camelCase (ej. `com.vehiclerental.service`, a
  definir el nombre final de paquete al llegar a la Fase 6).
- **Endpoints REST**: sustantivo en plural, minúscula, sin verbos, en inglés:
  - `GET /api/vehicles`, `GET /api/vehicles/{id}`, `POST /api/vehicles`,
    `PUT /api/vehicles/{id}`, `DELETE /api/vehicles/{id}`
  - Igual patrón para `/api/customers`, `/api/reservations`, `/api/rentals`.
- **Tablas en base de datos**: snake_case en plural, en inglés (`vehicles`, `customers`,
  `reservations`, `rentals`); Hibernate las genera solas a partir de los nombres de las entidades,
  no hace falta escribir SQL a mano en el MVP.
- **Validación de datos de entrada**: anotaciones de Bean Validation en las entidades/DTOs
  (`@NotBlank`, `@NotNull`, `@Email`, etc.), no si-elses manuales de validación.
- **Manejo de errores**: simple al principio (dejar que Spring devuelva el error por defecto o
  usar un único `@ControllerAdvice` genérico más adelante); no armar una jerarquía de excepciones
  custom para el MVP.
- **Comentarios**: en inglés, solo donde algo no es obvio (una regla de negocio, un cálculo). No
  comentar lo que el código ya dice solo.
- **Commits de git** (cuando se inicialice el repo): mensajes cortos en imperativo, en inglés,
  ej. `add Vehicle entity`, `implement reservation endpoint`.

## 7. Deuda técnica aceptada conscientemente en el MVP

Registrar acá lo que se simplificó a propósito, para no perderlo de vista:
- Sin DTOs: las entidades JPA se exponen directamente como JSON.
- **Sin autenticación/autorización de ningún tipo** (ni Empleado ni Cliente tienen login) —
  decisión explícita del usuario del proyecto. El cliente reserva vía un formulario público que
  pide datos básicos obligatorios (nombre, apellido, documento, email/teléfono) en cada reserva.
- Sin migraciones formales (Flyway/Liquibase): se usa `ddl-auto=update`.
- Sin manejo de errores centralizado sofisticado.
- Sin UI para el back-office del empleado; el formulario público de reserva del cliente sí
  necesita una UI mínima — a resolver en la Fase 5 (Mockup/Prototipo).

## 8. Skills / herramientas, mapeadas a las 6 fases

No existe en el entorno una skill específica de "estilo de código junior" ni una de "épicas e
historias de usuario"; por eso las Fases 1 y 2 se hacen a mano (buenas prácticas estándar de
historias de usuario e IEEE 830 simplificado para requerimientos), documentadas directamente en
`docs/`. El resto de las fases sí tienen skills del entorno que encajan:

| Fase | Skill a usar | Cuándo |
|---|---|---|
| 1. Épicas y Stories | *(sin skill — a mano)* | Ahora. |
| 2. Requerimientos | *(sin skill — a mano)* | Después de validar la Fase 1 con el usuario. |
| 3. Diagramas UML | `engineering:system-design` | Para formalizar casos de uso, clases y flujos a partir de los requerimientos. |
| 4. Base de datos | `engineering:system-design` (modelado de datos) | Para pasar del modelo conceptual al lógico/físico y generar el script SQL. |
| 5. Mockup/Prototipo | `frontend-design` + `artifact-design`/`artifact-diagramming` | Para armar un prototipo navegable simple como HTML/Artifact, sin depender de Figma. |
| 6. Programa funcional | `engineering:testing-strategy`, `/code-review`, `engineering:deploy-checklist` | Estrategia de tests una vez que exista el primer CRUD; `/code-review` después de cada feature chica; `deploy-checklist` cuando el MVP esté listo para desplegar. |

`engineering:architecture` (ADR) se usa solo si en algún momento aparece una decisión grande con
trade-offs reales — no hace falta para el MVP actual (la tabla de la sección 4 ya documenta el
razonamiento del stack). No se van a usar en este proyecto: `engineering:incident-response`,
`engineering:tech-debt`, `engineering:standup` — no aplican a un proyecto que recién arranca.

## 9. Estado actual

Fase: **3 — Diagramas UML, CERRADA** ✅ (ver `docs/00-roadmap.md` para el detalle de las 6 fases).

Hecho:
- Definido el stack y las convenciones técnicas (este archivo) — se van a aplicar recién en la
  Fase 6.
- Creado el esqueleto de carpetas Maven/Spring Boot (sin código de negocio); pendiente de
  renombrar a inglés al llegar a la Fase 6.
- `docs/00-roadmap.md` con el tracking de las 6 fases.
- `docs/01-epicas-historias-usuario.md`, **validado y cerrado por el usuario**: problema, objetivo,
  2 actores (Empleado sin login; Cliente sin cuenta, con formulario público de reserva), **5
  épicas** (Vehículos, Clientes, Reservas, Alquileres, Autogestión de Reservas del Cliente) con
  sus 21 historias de usuario, puntos de historia (estimación Fibonacci), dependencias entre
  historias y un diagrama Mermaid de user story map. Se evaluó y descartó manejar autenticación
  en el MVP — el cliente reserva directamente completando datos básicos obligatorios, sin cuenta.
- Corregida inconsistencia de versión de Java en `pom.xml` (quedó en 17, alineado con la sección 4
  de este archivo) — feedback del profesor sobre la Fase 1.
- `docs/02-requerimientos.md`, **validado y cerrado por el usuario**: 45 requerimientos
  funcionales (uno o más por historia), 8 no funcionales, 14 reglas de negocio, 8 restricciones,
  criterios de aceptación formales (Given/When/Then) para los casos más críticos, matriz de
  trazabilidad historia↔requerimiento, y un anexo de precios de referencia (investigación de
  mercado real, no vinculante) para datos de ejemplo de la Fase 6. Tres reglas de negocio clave
  (solapamiento de fechas, cálculo de días efectivos con tolerancia, bloqueo por alquiler activo)
  se definieron investigando cómo operan empresas reales de alquiler (Localiza, Avis, Enterprise)
  en vez de asumirlas arbitrariamente.
- Fase 3 dividida en 3 partes entre el equipo, agrupando las épicas de la Fase 1: Johann-Tafur
  (E1 Vehículos + E2 Clientes), chaarlyez (E3 Reservas + E5 Autogestión) y mariocardona970546
  (E4 Alquileres + integración final del diagrama de clases). Detalle de alcance y entregables de
  cada parte en `docs/03-uml/00-asignacion.md`.
- Las 3 partes de la Fase 3, **validadas y cerradas por el usuario**: `01-johann-tafur-vehiculos-
  clientes.md` (E1+E2: casos de uso, clases `Vehiculo`/`Cliente`, secuencia, estados y
  actividades), `02-reservas-chaarlyez.md` (E3+E5: casos de uso, clase `Reserva`, secuencia de
  reserva por empleado y reserva pública, actividades de validación de solapamiento) y
  `03-alquileres-mariocardona970546.md` (E4: casos de uso, clase `Alquiler`, secuencia y
  actividades de inicio/fin de alquiler, más la **integración final del diagrama de clases**
  combinando los aportes de las 3 partes en un solo modelo). `04-revision-integracion.md` deja
  registrada la revisión de coherencia entre las 3 (atributos, relaciones, multiplicidades y
  referencias cruzadas de casos de uso) sin contradicciones encontradas. Nota: la Fase 3 se había
  cerrado una primera vez (commits `d9d1e8d`, `e8c4377`, `1d4bc2a`) sin que la Parte 3 pasara su
  propio checklist de validación (quedó reabierta brevemente hasta corregir eso); el checklist de
  la sección 7 de `03-alquileres-mariocardona970546.md` ya está confirmado y la fase queda cerrada
  de verdad. Nota aparte: la skill `engineering:system-design` sugerida en la sección 8 no estaba
  disponible en ninguna de las sesiones donde se armó esta fase — se hizo a mano con diagramas
  Mermaid embebidos en los `.md`.

- Fase 4 dividida en 3 partes entre el equipo, misma agrupación de entidades que la Fase 3:
  Johann-Tafur (tablas `vehicles` + `customers`), chaarlyez (tabla `reservations`) y
  mariocardona970546 (tabla `rentals` + integración final del script SQL y diagrama ER). Detalle
  de alcance y entregables de cada parte en `docs/04-base-de-datos/00-asignacion.md`.
- Parte 3 (mariocardona970546) entregada: `docs/04-base-de-datos/03-alquileres-mariocardona970546.md`
  con el modelo lógico, constraints y script SQL de `rentals`. La integración final del script SQL
  completo y el diagrama ER (tarea propia de esta parte) queda pendiente hasta que Johann-Tafur
  suba `vehicles`/`customers` — no se inventaron sus columnas para no repetir el error de la Fase 3
  (asumir alcance de otra parte).

Próximo paso: falta que Johann-Tafur entregue su parte de la **Fase 4 (Base de datos)** —
`vehicles` + `customers`. Cuando esté, mariocardona970546 arma la integración final del script SQL
y el diagrama ER completo, y se hace la revisión de coherencia cruzada entre las 3 partes.
