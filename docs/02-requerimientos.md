# Fase 2 — Requerimientos

Este documento formaliza, en base a `docs/01-epicas-historias-usuario.md` (Fase 1, cerrada), los
requerimientos funcionales y no funcionales, las reglas de negocio, las restricciones y los
criterios de aceptación del MVP. Sigue una versión simplificada de IEEE 830, adecuada al nivel
junior del proyecto (ver `CLAUDE.md`).

**Convención de numeración**: RF (Requerimiento Funcional), RNF (Requerimiento No Funcional), RN
(Regla de Negocio), RE (Restricción). Cada RF referencia entre paréntesis la(s) historia(s) de
usuario de la que se deriva.

---

## 1. Alcance

Cubre las 5 épicas y 21 historias de usuario de la Fase 1: gestión de vehículos (E1), gestión de
clientes (E2), gestión de reservas (E3), gestión de alquileres (E4) y autogestión de reservas del
cliente sin login (E5). No cubre nada fuera del MVP definido en `CLAUDE.md` sección 2 (pagos,
autenticación, roles, notificaciones, reportes, multi-sucursal).

---

## 2. Requerimientos funcionales (RF)

### 2.1 Vehículos (E1)

| ID | Requerimiento | Historia(s) |
|---|---|---|
| **RF01** | El sistema debe permitir registrar un vehículo nuevo con patente, marca, modelo, año, tipo y precio por día. | US1.1 |
| **RF02** | El sistema debe rechazar el registro de un vehículo si falta patente, marca, modelo o precio por día. | US1.1 |
| **RF03** | El sistema debe impedir el registro de dos vehículos con la misma patente. | US1.1 |
| **RF04** | Al registrarse, un vehículo debe quedar automáticamente en estado "Disponible". | US1.1 |
| **RF05** | El sistema debe permitir listar los vehículos registrados, mostrando patente, marca, modelo y estado. | US1.2 |
| **RF06** | El sistema debe permitir filtrar el listado de vehículos por estado. | US1.2 |
| **RF07** | El sistema debe permitir modificar los datos de un vehículo existente. | US1.3 |
| **RF08** | El sistema debe impedir modificar la patente de un vehículo a una ya usada por otro vehículo. | US1.3 |
| **RF09** | Los campos obligatorios (patente, marca, modelo, precio por día) deben seguir siendo obligatorios al modificar un vehículo. | US1.3 |
| **RF10** | El sistema debe permitir dar de baja un vehículo. | US1.4 |
| **RF11** | El sistema debe impedir dar de baja un vehículo que tenga un alquiler activo. | US1.4 |
| **RF12** | El sistema debe permitir buscar vehículos disponibles en un rango de fechas dado. | US1.5 |
| **RF13** | La búsqueda de disponibilidad debe excluir vehículos con una reserva (PENDIENTE o CONFIRMADA) que se solape con el rango pedido (ver RN12), o con un alquiler en estado ACTIVO (ver RN14). | US1.5, US3.2 |
| **RF14** | El sistema debe permitir marcar y desmarcar un vehículo como "En mantenimiento", independientemente de un alquiler. | US1.6 |
| **RF15** | El sistema debe impedir marcar en mantenimiento un vehículo que tenga un alquiler activo. | US1.6 |

### 2.2 Clientes (E2)

| ID | Requerimiento | Historia(s) |
|---|---|---|
| **RF16** | El sistema debe permitir registrar un cliente nuevo con nombre, apellido, documento, email y teléfono. | US2.1 |
| **RF17** | El sistema debe rechazar el registro de un cliente si falta nombre, apellido o documento. | US2.1 |
| **RF18** | El sistema debe impedir el registro de dos clientes con el mismo documento. | US2.1 |
| **RF19** | El sistema debe permitir buscar un cliente por documento (resultado único). | US2.2 |
| **RF20** | El sistema debe permitir buscar clientes por apellido (puede devolver varios resultados). | US2.2 |
| **RF21** | El sistema debe permitir modificar los datos de un cliente existente. | US2.3 |
| **RF22** | El sistema debe impedir modificar el documento de un cliente a uno ya usado por otro cliente. | US2.3 |
| **RF23** | El sistema debe permitir eliminar un cliente. | US2.4 |
| **RF24** | El sistema debe impedir eliminar un cliente que tenga reservas o alquileres activos. | US2.4 |

### 2.3 Reservas (E3)

| ID | Requerimiento | Historia(s) |
|---|---|---|
| **RF25** | El sistema debe permitir crear una reserva indicando cliente, vehículo, fecha de inicio y fecha de fin. | US3.1 |
| **RF26** | El sistema debe validar que la fecha de fin de una reserva sea posterior a la fecha de inicio. | US3.1 |
| **RF27** | El sistema debe validar que el cliente y el vehículo indicados en una reserva existan (y que el vehículo no esté dado de baja). | US3.1 |
| **RF28** | El sistema debe rechazar una reserva cuyo rango de fechas se solape con otra reserva PENDIENTE o CONFIRMADA del mismo vehículo (RN12), o si el vehículo tiene un alquiler en estado ACTIVO (RN14). | US3.2 |
| **RF29** | El sistema debe permitir listar reservas, filtrando por cliente, vehículo o estado. | US3.3 |
| **RF30** | El sistema debe permitir cancelar una reserva. | US3.4 |
| **RF31** | El sistema debe impedir cancelar una reserva que ya derivó en un alquiler. | US3.4 |
| **RF32** | El sistema debe permitir confirmar una reserva en estado PENDIENTE, pasándola a CONFIRMADA. | US3.5 |
| **RF33** | El sistema debe impedir confirmar una reserva que no esté en estado PENDIENTE. | US3.5 |

### 2.4 Alquileres (E4)

| ID | Requerimiento | Historia(s) |
|---|---|---|
| **RF34** | El sistema debe permitir iniciar un alquiler a partir de una reserva confirmada, o de forma directa sin reserva previa. | US4.1 |
| **RF35** | Al iniciar un alquiler, el sistema debe cambiar el estado del vehículo a "Alquilado". | US4.1 |
| **RF36** | El sistema debe impedir iniciar un alquiler sobre un vehículo que ya está en estado "Alquilado". | US4.1 |
| **RF37** | El sistema debe permitir finalizar un alquiler registrando la fecha real de devolución. | US4.2 |
| **RF38** | Al finalizar un alquiler, el sistema debe calcular el monto total en base a los días efectivamente alquilados (RN13) y el precio por día del vehículo. | US4.2 |
| **RF39** | Al finalizar un alquiler, el sistema debe devolver el vehículo a estado "Disponible" o "Mantenimiento", según indique el empleado. | US4.2 |
| **RF40** | El sistema debe permitir listar alquileres, distinguiendo activos de finalizados. | US4.3 |
| **RF41** | El sistema debe permitir consultar el historial de alquileres de un cliente puntual, buscando por documento. | US4.4 |

### 2.5 Autogestión de reservas del cliente (E5)

| ID | Requerimiento | Historia(s) |
|---|---|---|
| **RF42** | El sistema debe exponer una búsqueda pública (sin login) de vehículos disponibles en un rango de fechas. | US5.1 |
| **RF43** | El sistema debe permitir a un cliente crear una reserva pública completando nombre, apellido, documento y al menos un dato de contacto (email o teléfono). | US5.2 |
| **RF44** | Si el documento ingresado en una reserva pública ya corresponde a un Cliente existente, el sistema debe reutilizar ese registro en vez de crear uno duplicado. | US5.2 |
| **RF45** | La reserva creada por el formulario público debe cumplir las mismas validaciones de disponibilidad y de fechas que una reserva creada por un empleado (RF26, RF28). | US5.2 |

---

## 3. Requerimientos no funcionales (RNF)

> Nota: la ausencia de autenticación/autorización en el MVP **no** se lista acá como atributo de
> calidad — es una decisión de alcance y está documentada como restricción en **RE03**.

| ID | Requerimiento |
|---|---|
| **RNF01** | **Usabilidad** — Los mensajes de error de validación deben ser claros y describir qué campo o regla falló, tanto en la API (back-office) como en el formulario público. |
| **RNF02** | **Persistencia** — Los datos deben guardarse en PostgreSQL y sobrevivir a un reinicio de la aplicación. |
| **RNF03** | **Rendimiento** — Las operaciones de listado y búsqueda de disponibilidad deben responder en menos de 2 segundos con los volúmenes de datos esperados para el MVP (cientos de vehículos, miles de reservas/alquileres). |
| **RNF04** | **Portabilidad** — El backend debe ejecutarse sobre Java 17 y ser independiente del sistema operativo (cualquier SO con JVM 17). |
| **RNF05** | **Mantenibilidad** — El código debe seguir la arquitectura en capas y las convenciones de nombres definidas en `CLAUDE.md`, de forma que un desarrollador junior pueda entenderlo sin contexto previo. |
| **RNF06** | **Compatibilidad** — La API REST del back-office debe consumir y devolver JSON. |
| **RNF07** | **Simplicidad de despliegue** — El sistema debe poder levantarse localmente solo con `application.properties` y una base PostgreSQL, sin dependencias externas adicionales. |
| **RNF08** | **Accesibilidad del formulario público** — El formulario de reserva del cliente (E5) debe ser utilizable desde un navegador de escritorio y de celular (diseño responsive), ya que el cliente accede sin asistencia de un empleado. |

---

## 4. Reglas de negocio (RN)

| ID | Regla |
|---|---|
| **RN01** | Un vehículo está en exactamente uno de estos tres estados a la vez: Disponible, Alquilado o Mantenimiento. |
| **RN02** | Dos reservas del mismo vehículo no pueden tener rangos de fechas que se solapen (RN12) mientras ambas estén en estado PENDIENTE o CONFIRMADA. El bloqueo de una reserva contra un alquiler activo está cubierto aparte por RN14, no por esta regla. |
| **RN03** | Una reserva CANCELADA no bloquea la disponibilidad del vehículo. |
| **RN04** | Un alquiler puede originarse a partir de una reserva CONFIRMADA, o crearse directamente sin reserva previa. |
| **RN05** | El monto total de un alquiler se calcula como: *días efectivamente alquilados (RN13) × precio por día del vehículo*. |
| **RN06** | Un cliente se identifica de forma única por su documento; no puede haber dos registros de Cliente con el mismo documento. |
| **RN07** | Un vehículo se identifica de forma única por su patente; no puede haber dos registros de Vehículo con la misma patente. |
| **RN08** | No se puede eliminar/dar de baja un Vehículo ni un Cliente que tenga reservas o alquileres activos asociados. |
| **RN09** | Toda reserva nace en estado PENDIENTE, salvo que se confirme explícitamente (US3.5) pasando a CONFIRMADA. |
| **RN10** | En el formulario público (E5), si el documento ingresado coincide con un Cliente ya existente, se reutiliza ese registro; si no existe, se crea uno nuevo automáticamente con los datos provistos. |
| **RN11** | Un alquiler sin reserva previa ocupa la disponibilidad del vehículo igual que uno originado en una reserva (el vehículo pasa a "Alquilado" en ambos casos). |
| **RN12** | **Fórmula de solapamiento de fechas**: dos rangos `[inicioA, finA]` y `[inicioB, finB]` se consideran solapados si `inicioA <= finB` y `finA >= inicioB`. Ambas fechas límite son inclusive: el vehículo se considera ocupado también en el día de `fechaFin`. |
| **RN13** | **Cálculo de días efectivos**: se calculan como la diferencia en días de calendario entre la fecha de inicio real y la fecha de fin real de un alquiler (ej.: retiro el día 1, devolución el día 4 → 3 días efectivos). El MVP no factura por horas ni fracciones de día; si se necesita en el futuro, es una extensión fuera de alcance. |
| **RN14** | Mientras un vehículo tenga un alquiler en estado ACTIVO (es decir, sin fecha de devolución real todavía registrada), no se le puede crear ninguna reserva nueva, sin importar el rango de fechas solicitado — no hay una fecha de fin conocida contra la cual verificar solapamiento. |

> ⚠️ **RN12, RN13 y RN14 son supuestos propios (no vinieron explícitos de la Fase 1)**, agregados
> para poder programar la Fase 6 sin ambigüedad. En particular RN14 resuelve una inconsistencia
> real que tenía la Fase 1: US1.5 (búsqueda de disponibilidad) ya excluía vehículos con reserva
> *o alquiler* solapado, pero el criterio de aceptación de US3.2 (crear reserva) solo mencionaba
> solapamiento contra *otra reserva*. Revisar con atención antes de cerrar esta fase.

---

## 5. Restricciones (RE)

| ID | Restricción |
|---|---|
| **RE01** | El sistema se desarrolla en Java 17 con Spring Boot 3 (Web, Data JPA, Validation) y Maven (decisión de stack, `CLAUDE.md` sección 4). |
| **RE02** | La base de datos debe ser PostgreSQL. |
| **RE03** | No se implementa autenticación, autorización ni roles/permisos en el MVP (decisión de alcance confirmada, `CLAUDE.md` sección 3/7). |
| **RE04** | Quedan fuera del MVP: pagos/facturación, notificaciones, reportes y multi-sucursal (`CLAUDE.md` sección 2). |
| **RE05** | Las entidades JPA se exponen directamente como JSON en las respuestas de la API, sin capa de DTOs (deuda técnica aceptada). |
| **RE06** | El esquema de base de datos se genera con `ddl-auto=update` de Hibernate; no se usan migraciones formales (Flyway/Liquibase) en el MVP. |
| **RE07** | El proyecto se desarrolla a nivel junior: se prioriza código simple y legible sobre patrones avanzados (`CLAUDE.md` sección 1). |
| **RE08** | El back-office de Empleado se opera vía API REST sin interfaz propia (se prueba por Postman/curl); solo el formulario de reserva del Cliente (E5) requiere una UI mínima, a diseñar en la Fase 5. |

---

## 6. Criterios de aceptación formales

Cada historia de usuario ya tiene criterios de aceptación en `docs/01-epicas-historias-usuario.md`.
Esta sección los formaliza, en formato Given/When/Then, para los requerimientos más críticos o con
mayor riesgo de bugs — los que conviene tener claros antes de programarlos y usar como base de los
tests de la Fase 6.

**RF03 — patente duplicada**
- Given no existe ningún vehículo con la patente "AB123CD"
- When se registra un vehículo con esa patente
- Then el vehículo se crea correctamente
- Given ya existe un vehículo con la patente "AB123CD"
- When se intenta registrar otro vehículo con la misma patente
- Then el sistema rechaza la operación y no crea un segundo registro

**RF13 / RF28 — solapamiento de fechas entre reservas**
- Given un vehículo con una reserva CONFIRMADA del día 10 al día 15 de un mes (ambos inclusive)
- When se busca su disponibilidad para el rango 12-14 del mismo mes
- Then el vehículo no aparece en el resultado
- Given la misma reserva (10 al 15)
- When se intenta crear una nueva reserva del mismo vehículo para el rango 14-20 (se solapan los días 14 y 15)
- Then la nueva reserva es rechazada con un mensaje que indica el conflicto
- Given la misma reserva (10 al 15)
- When se intenta crear una nueva reserva del mismo vehículo para el rango 16-20 (no comparte ningún día)
- Then la nueva reserva se crea correctamente

**RF13 / RF28 — bloqueo por alquiler activo (RN14)**
- Given un vehículo con un alquiler en estado ACTIVO (sin fecha de devolución real registrada)
- When se intenta crear una reserva para ese vehículo, en cualquier rango de fechas futuro
- Then la reserva es rechazada, porque no hay una fecha de fin conocida contra la cual comparar

**RF24 — eliminar cliente con actividad**
- Given un cliente con una reserva en estado CONFIRMADA
- When se intenta eliminar ese cliente
- Then el sistema rechaza la eliminación
- Given un cliente sin reservas ni alquileres activos
- When se intenta eliminar ese cliente
- Then el cliente se elimina correctamente

**RF31 — cancelar reserva ya convertida en alquiler**
- Given una reserva que ya generó un alquiler (RF34)
- When se intenta cancelar esa reserva
- Then el sistema rechaza la cancelación

**RF33 — confirmar una reserva que no está PENDIENTE**
- Given una reserva en estado CANCELADA (o ya CONFIRMADA)
- When se intenta confirmarla
- Then el sistema rechaza la operación

**RF36 — doble alquiler del mismo vehículo**
- Given un vehículo en estado "Alquilado"
- When se intenta iniciar un nuevo alquiler sobre ese mismo vehículo
- Then el sistema rechaza la operación

**RF38 — cálculo del monto**
- Given un vehículo con precio por día de $10.000
- And un alquiler iniciado el día 1 y finalizado el día 4 (3 días efectivos, RN13)
- When se finaliza el alquiler
- Then el monto total calculado es $30.000

**RF44 — reutilización de cliente en reserva pública**
- Given ya existe un Cliente con documento "30111222"
- When se crea una reserva pública con ese mismo documento
- Then la reserva queda asociada al Cliente existente y no se crea un Cliente duplicado
- Given no existe ningún Cliente con documento "40333444"
- When se crea una reserva pública con ese documento
- Then el sistema crea un Cliente nuevo con los datos provistos y le asocia la reserva

---

## 7. Matriz de trazabilidad: historias ↔ requerimientos

| Historia | Épica | Requerimientos funcionales |
|---|---|---|
| US1.1 | E1 | RF01, RF02, RF03, RF04 |
| US1.2 | E1 | RF05, RF06 |
| US1.3 | E1 | RF07, RF08, RF09 |
| US1.4 | E1 | RF10, RF11 |
| US1.5 | E1 | RF12, RF13 |
| US1.6 | E1 | RF14, RF15 |
| US2.1 | E2 | RF16, RF17, RF18 |
| US2.2 | E2 | RF19, RF20 |
| US2.3 | E2 | RF21, RF22 |
| US2.4 | E2 | RF23, RF24 |
| US3.1 | E3 | RF25, RF26, RF27 |
| US3.2 | E3 | RF13, RF28 |
| US3.3 | E3 | RF29 |
| US3.4 | E3 | RF30, RF31 |
| US3.5 | E3 | RF32, RF33 |
| US4.1 | E4 | RF34, RF35, RF36 |
| US4.2 | E4 | RF37, RF38, RF39 |
| US4.3 | E4 | RF40 |
| US4.4 | E4 | RF41 |
| US5.1 | E5 | RF42 |
| US5.2 | E5 | RF43, RF44, RF45 |

Cobertura: las 21 historias de la Fase 1 tienen al menos un RF asociado, y los 45 RF cubren al
menos una historia — no hay RF "huérfano" ni historia sin requerimiento formalizado.

---

## 8. Qué falta validar antes de pasar a la Fase 3

- [ ] ¿Los 45 requerimientos funcionales reflejan correctamente cada historia de usuario, o falta/sobra alguno?
- [ ] ¿Las reglas de negocio (sección 4) coinciden con cómo opera realmente la empresa? En particular:
      - **RN14**: ¿un vehículo con un alquiler ACTIVO debe bloquear *cualquier* reserva nueva (como quedó definido), o la empresa maneja de otra forma la superposición entre un alquiler en curso y una reserva futura (ej. si el alquiler tiene una fecha de devolución *estimada* aunque no confirmada)?
      - **RN12**: ¿las fechas límite de una reserva/alquiler son inclusive (el vehículo está ocupado también el día de `fechaFin`), como se asumió?
      - **RN13**: ¿el cálculo de "días efectivos" por diferencia de días de calendario (sin fracciones de hora) es aceptable para el MVP, o la empresa cobra por hora en el día de devolución?
      - RN09 (toda reserva nace PENDIENTE) y RN05 (fórmula del monto) — ya confirmados conceptualmente, sin cambios en esta revisión.
- [ ] ¿Los requerimientos no funcionales (rendimiento, disponibilidad de datos, etc.) son razonables para el contexto del MVP, o hay alguno de más/de menos?
- [ ] ¿Están de acuerdo con los criterios de aceptación formales elegidos (sección 6), o hay otro caso crítico que convenga agregar?
