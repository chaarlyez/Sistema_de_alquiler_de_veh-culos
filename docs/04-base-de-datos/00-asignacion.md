# Fase 4 — Base de datos: división del trabajo

La Fase 4 se divide en 3 partes, una por integrante, siguiendo la misma agrupación de entidades
que se usó en la Fase 3 (`docs/03-uml/00-asignacion.md`) para mantener a cada integrante dueño de
las mismas clases de punta a punta: quien modeló una clase en UML pasa esa clase a tabla acá.

Cada parte entrega, para sus tablas: modelo lógico (columnas, tipos de dato, claves primaria y
foránea, constraints), script SQL (`CREATE TABLE`) en PostgreSQL, y su porción del diagrama
entidad-relación (ER).

El **script SQL completo y el diagrama ER** son uno solo para todo el sistema (las tablas se
relacionan entre sí mediante FKs), así que cada parte aporta sus tablas y quien integra arma la
versión final unificada — igual mecánica que con el diagrama de clases en la Fase 3.

Punto de partida común: el diagrama de clases integrado de
`docs/03-uml/03-alquileres-mariocardona970546.md` sección 3, y las convenciones de nombres de
`CLAUDE.md` sección 6 (tablas en `snake_case` plural, en inglés: `vehicles`, `customers`,
`reservations`, `rentals`).

## Parte 1 — Johann-Tafur

**Alcance**: tablas `vehicles` y `customers` (a partir de las clases `Vehiculo`/`Cliente` que ya
modeló en la Fase 3, parte 1).

- Modelo lógico: columnas, tipos (`BIGSERIAL`, `VARCHAR`, `NUMERIC`, enum como `VARCHAR` +
  `CHECK`, etc.), claves primarias.
- Constraints propios: `license_plate` único en `vehicles`; `document_number` único en
  `customers`.
- Script SQL: `CREATE TABLE vehicles`, `CREATE TABLE customers`.
- Su porción del diagrama ER (las dos tablas, sin FKs salientes — son el lado "1" de las
  relaciones con `reservations` y `rentals`).

## Parte 2 — chaarlyez

**Alcance**: tabla `reservations` (a partir de la clase `Reserva` que ya modeló en la Fase 3,
parte 2).

- Modelo lógico: columnas, FK a `vehicles` y `customers`, tipo de `status` (enum
  `PENDING`/`CONFIRMED`/`CANCELLED`).
- Constraints propios: `start_date <= end_date`; índice sobre `(vehicle_id, start_date, end_date)`
  para soportar la validación de solapamiento (RN12) de forma eficiente.
- Script SQL: `CREATE TABLE reservations`.
- Su porción del diagrama ER (la tabla `reservations` con sus dos FKs).

## Parte 3 — mariocardona970546

**Alcance**: tabla `rentals` (a partir de la clase `Alquiler` que ya modeló en la Fase 3, parte 3)
+ integración final del script SQL y del diagrama ER completo.

- Modelo lógico: columnas, FK a `vehicles`, `customers` y `reservations` (esta última opcional,
  `NULL` permitido — un alquiler puede ser directo, sin reserva de origen, RN04), tipo de `status`
  (enum `ACTIVE`/`FINISHED`), `total_amount` como `NUMERIC`.
- Constraints propios: `actual_start_date` no nulo; `total_amount >= 0`.
- Script SQL: `CREATE TABLE rentals`.
- **Integración final**: un único script SQL con las 4 tablas en el orden correcto de creación
  (`vehicles`, `customers` → `reservations` → `rentals`, por las dependencias de FK) y el diagrama
  ER completo del sistema, igual mecánica que la integración del diagrama de clases en la Fase 3.

## Notas

- Nivel junior: sin migraciones formales (Flyway/Liquibada) — el script SQL de esta fase es
  documentación/diseño del modelo, no necesariamente lo que ejecuta Hibernate en la Fase 6
  (`ddl-auto=update`, ver `CLAUDE.md` sección 4).
- Ojo con los tipos: `fechaInicioReal`/`fechaFinReal` de `Alquiler` necesitan hora, no solo fecha
  (`TIMESTAMP`, no `DATE`) por RN13 (tolerancia de 1 hora); `montoTotal`/`precioPorDia` van como
  `NUMERIC`, no `FLOAT`/`DOUBLE`, para evitar errores de redondeo en dinero.
- Mismo criterio que en la Fase 3: diagramas simples y legibles, sin sobre-normalizar ni agregar
  tablas que no pide el MVP (ver `CLAUDE.md`, sección 1).
