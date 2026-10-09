# Fase 1 — Épicas e Historias de Usuario

## 1. Problema

Una empresa de alquiler de vehículos gestiona hoy su operación de forma manual/desordenada
(planillas, papel, memoria). Esto genera errores como alquilar dos veces el mismo vehículo en las
mismas fechas, perder el registro de qué vehículo está con qué cliente, o no saber qué unidades
están disponibles en un momento dado.

## 2. Objetivo

Construir un sistema que centralice el control de vehículos, clientes, reservas y alquileres, para
que el personal de la empresa pueda operar sin errores de disponibilidad y con información
actualizada del estado de la flota.

## 3. Usuarios / Actores

| Actor | Descripción |
|---|---|
| **Empleado** | Persona que usa el sistema día a día: registra vehículos, gestiona reservas y alquileres creados por cualquier vía. |
| **Cliente** | Persona que alquila un vehículo. Puede reservar **por su cuenta** desde un formulario público, **sin necesidad de cuenta ni login** — en cada reserva completa sus datos básicos obligatorios (nombre, apellido, documento, email, teléfono). |

> **Decisión confirmada**: no se maneja seguridad/autenticación en el MVP (ni para Empleado ni para
> Cliente). El "autoservicio" del cliente no es un portal con cuenta propia, sino un formulario de
> reserva público que exige datos básicos obligatorios. Si el documento ingresado ya existe como
> Cliente (porque un empleado lo cargó antes, o porque reservó previamente), el sistema reutiliza
> ese registro en vez de duplicarlo; si no existe, lo crea.

> **Decisión confirmada — borrado lógico** (cambio agregado después del cierre de la fase, ver
> `docs/cambios/01-borrado-logico.md`): **ningún dato se elimina físicamente**. "Eliminar" un
> registro significa ocultarlo: el vehículo pasa a **Retirado**, el cliente queda **inactivo**, la
> reserva queda **Cancelada** y el alquiler queda **Anulado**. Así se conserva el historial
> (alquileres pasados, montos cobrados) y un registro dado de baja se puede volver a usar
> reactivándolo, en vez de cargarlo de nuevo.

## 4. Épicas

El MVP se dividió en 5 épicas: las 4 originales de la consigna, más 1 nueva para que el cliente
pueda reservar directamente sin pasar por un empleado (sin login, con datos básicos obligatorios):

- **E1 — Gestión de Vehículos**
- **E2 — Gestión de Clientes**
- **E3 — Gestión de Reservas**
- **E4 — Gestión de Alquileres**
- **E5 — Autogestión de Reservas del Cliente** *(nueva, sin login)*

---

## E1 — Gestión de Vehículos

*Como empleado, necesito administrar la flota de vehículos para saber qué unidades existen y
cuáles están disponibles para alquilar.*

| ID | Historia de usuario | Pts | Depende de | Criterios de aceptación |
|---|---|---|---|---|
| **US1.1** | Como empleado, quiero **registrar un vehículo nuevo** (patente, marca, modelo, año, tipo, precio por día) para poder ofrecerlo en alquiler. | 3 | — | - No se permite guardar sin patente, marca, modelo o precio por día.<br>- No se permite registrar dos vehículos con la misma patente.<br>- Al crearse, el vehículo queda con estado "Disponible". |
| **US1.2** | Como empleado, quiero **ver el listado de vehículos** con su estado actual (Disponible / Alquilado / Mantenimiento / Retirado) para saber de un vistazo qué hay en la flota. | 2 | US1.1 | - El listado muestra patente, marca, modelo y estado.<br>- Se puede filtrar por estado.<br>- Por defecto no muestra los vehículos Retirados; se pueden ver pidiéndolo explícitamente. |
| **US1.3** | Como empleado, quiero **modificar los datos de un vehículo** para corregir errores de carga o actualizar información (ej. precio por día). | 2 | US1.1 | - No se puede modificar la patente a una que ya exista en otro vehículo.<br>- Los campos obligatorios siguen siendo obligatorios al editar. |
| **US1.4** | Como empleado, quiero **dar de baja un vehículo** que ya no se va a usar para alquilar (vendido, siniestrado, fin de vida útil), sin perder su historial. | 2 | US1.1, US3.1, US4.1 *(chequea reservas y alquiler activo)* | - La baja es lógica: el vehículo pasa a estado "Retirado" y sus datos y su historial de reservas/alquileres se conservan.<br>- No se puede dar de baja un vehículo con un alquiler activo ni con reservas Pendientes o Confirmadas.<br>- Un vehículo Retirado no aparece en las búsquedas de disponibilidad ni en el listado por defecto, y no se le pueden crear reservas ni alquileres. |
| **US1.5** | Como empleado, quiero **buscar vehículos disponibles en un rango de fechas** para poder ofrecérselos a un cliente que llama. | 5 | US1.1, US3.1, US4.1 *(cruza datos de reserva/alquiler)* | - La búsqueda excluye vehículos con una reserva o alquiler que se solape con el rango pedido.<br>- Si no hay resultados, se informa claramente que no hay unidades disponibles. |
| **US1.6** | Como empleado, quiero **marcar un vehículo como "En mantenimiento"** fuera del flujo de un alquiler (ej. service programado), para sacarlo de disponibilidad sin que haya un alquiler de por medio. | 2 | US1.1, US4.1 *(chequea alquiler activo)* | - No se puede marcar en mantenimiento un vehículo con un alquiler activo.<br>- Un vehículo en mantenimiento no aparece en la búsqueda de disponibilidad (US1.5/US5.1).<br>- El empleado puede volver a marcarlo como "Disponible" cuando termina el service. |
| **US1.7** | Como empleado, quiero **reactivar un vehículo dado de baja** (ej. se dio de baja por error, o vuelve a la flota después de una reparación larga), para no tener que cargarlo de nuevo. | 1 | US1.4 | - Solo un vehículo "Retirado" se puede reactivar; vuelve a estado "Disponible".<br>- Si se intenta registrar un vehículo con la patente de uno Retirado, el sistema lo rechaza e indica que existe dado de baja y que se puede reactivar. |

*Subtotal E1: 17 puntos.*

---

## E2 — Gestión de Clientes

*Como empleado, necesito administrar los datos de los clientes para poder asociarlos a reservas y
alquileres.*

| ID | Historia de usuario | Pts | Depende de | Criterios de aceptación |
|---|---|---|---|---|
| **US2.1** | Como empleado, quiero **registrar un cliente nuevo** (nombre, apellido, documento, email, teléfono) para poder hacerle una reserva o un alquiler. | 3 | — | - No se permite guardar sin nombre, apellido o documento.<br>- No se permite registrar dos clientes con el mismo documento (tampoco si el existente está inactivo: en ese caso se indica que se puede reactivar). |
| **US2.2** | Como empleado, quiero **buscar un cliente** por documento o apellido para no tener que cargarlo de nuevo si ya existe. | 2 | US2.1 | - La búsqueda por documento devuelve como máximo un resultado (es único).<br>- La búsqueda por apellido puede devolver varios resultados.<br>- Por defecto no muestra clientes inactivos; se pueden incluir pidiéndolo explícitamente. |
| **US2.3** | Como empleado, quiero **modificar los datos de un cliente** (ej. teléfono, email) para mantenerlos actualizados. | 2 | US2.1 | - No se puede modificar el documento a uno que ya exista en otro cliente. |
| **US2.4** | Como empleado, quiero **desactivar (dar de baja) un cliente** que ya no opera con la empresa o que pidió darse de baja, sin perder su historial. | 2 | US2.1, US3.1, US4.1 *(chequea reservas/alquileres activos)* | - La baja es lógica: el cliente queda inactivo (oculto) y sus datos e historial se conservan.<br>- No se puede desactivar un cliente con reservas Pendientes/Confirmadas o alquileres activos.<br>- A un cliente inactivo no se le pueden crear reservas ni alquileres desde el back-office. |
| **US2.5** | Como empleado, quiero **reactivar un cliente inactivo** que vuelve a operar con la empresa, para reutilizar sus datos sin cargarlo de nuevo. | 1 | US2.4 | - Solo un cliente inactivo se puede reactivar.<br>- Al reactivarse vuelve a aparecer en las búsquedas y conserva su historial previo. |

*Subtotal E2: 10 puntos.*

---

## E3 — Gestión de Reservas

*Como empleado, necesito reservar un vehículo para un cliente en fechas futuras, garantizando que
no se pisen dos reservas del mismo vehículo.*

| ID | Historia de usuario | Pts | Depende de | Criterios de aceptación |
|---|---|---|---|---|
| **US3.1** | Como empleado, quiero **crear una reserva** indicando cliente, vehículo, fecha de inicio y fecha de fin. | 3 | US1.1, US2.1 | - La fecha de fin debe ser posterior a la de inicio.<br>- El vehículo debe existir y no estar Retirado.<br>- El cliente debe existir y estar activo. |
| **US3.2** | Como empleado, cuando creo una reserva, quiero que **el sistema valide que el vehículo esté disponible** en ese rango de fechas, para no reservar dos veces la misma unidad. | 5 | US3.1, US1.5 *(misma lógica de solapamiento)* | - Si el rango se solapa con otra reserva CONFIRMADA o PENDIENTE del mismo vehículo, la reserva se rechaza con un mensaje claro. |
| **US3.3** | Como empleado, quiero **ver el listado de reservas**, filtrando por cliente, vehículo o estado, para hacer seguimiento. | 3 | US3.1 | - El listado muestra cliente, vehículo, fechas y estado. |
| **US3.4** | Como empleado, quiero **cancelar una reserva** que el cliente no va a usar, para liberar el vehículo en esas fechas. | 2 | US3.1 | - Una reserva cancelada no vuelve a bloquear la disponibilidad del vehículo.<br>- No se puede cancelar una reserva que ya se convirtió en alquiler.<br>- La reserva cancelada no se borra: queda en el historial con estado Cancelada. |
| **US3.5** | Como empleado, quiero **confirmar una reserva pendiente** para dejar asentado que el cliente la validó (ej. con una seña). | 1 | US3.1 | - Solo una reserva en estado PENDIENTE puede pasar a CONFIRMADA. |

*Subtotal E3: 14 puntos.*

---

## E4 — Gestión de Alquileres

*Como empleado, necesito registrar el momento en que el cliente retira y devuelve el vehículo, y
saber cuánto tiene que pagar.*

| ID | Historia de usuario | Pts | Depende de | Criterios de aceptación |
|---|---|---|---|---|
| **US4.1** | Como empleado, quiero **iniciar un alquiler** (retiro del vehículo) a partir de una reserva confirmada, o de forma directa sin reserva previa. | 3 | US1.1, US2.1, US3.5 *(reserva confirmada, opcional)* | - Al iniciar el alquiler, el vehículo pasa a estado "Alquilado".<br>- No se puede iniciar un alquiler sobre un vehículo que ya está "Alquilado" o "Retirado", ni para un cliente inactivo. |
| **US4.2** | Como empleado, quiero **finalizar un alquiler** (devolución del vehículo) registrando la fecha real de devolución, para calcular el monto a cobrar. | 5 | US4.1 | - El monto total se calcula en base a los días efectivamente alquilados y el precio por día del vehículo.<br>- Al finalizar, el vehículo vuelve a estado "Disponible" (o "Mantenimiento" si el empleado lo marca así). |
| **US4.3** | Como empleado, quiero **ver el listado de alquileres activos, finalizados y anulados**, para saber qué vehículos están afuera y cuáles ya volvieron. | 2 | US4.1 | - El listado muestra cliente, vehículo, fechas, estado y monto.<br>- Por defecto no muestra los alquileres Anulados; se pueden ver filtrando por estado. |
| **US4.4** | Como empleado, quiero **consultar el historial de alquileres de un cliente puntual**, para atenderlo mejor si llama con una consulta o reclamo. | 3 | US2.1, US4.1 | - Se puede buscar el historial por documento del cliente.<br>- El historial muestra alquileres pasados y activos, con fechas y vehículo.<br>- El historial sigue disponible aunque el cliente o el vehículo estén dados de baja. |
| **US4.5** | Como empleado, quiero **anular un alquiler activo** que se registró por error (ej. el cliente finalmente no se llevó el vehículo, o se eligió mal la unidad), sin borrarlo. | 2 | US4.1 | - Solo un alquiler Activo se puede anular; uno Finalizado no (ya se cobró).<br>- El alquiler queda en estado "Anulado", sin monto, y el vehículo vuelve a "Disponible".<br>- Si el alquiler venía de una reserva, esa reserva pasa a "Cancelada". |

*Subtotal E4: 15 puntos.*

---

## E5 — Autogestión de Reservas del Cliente

*Como cliente, necesito poder reservar un vehículo por mi cuenta sin depender de un empleado, sin
necesidad de crear una cuenta.*

| ID | Historia de usuario | Pts | Depende de | Criterios de aceptación |
|---|---|---|---|---|
| **US5.1** | Como cliente, quiero **buscar vehículos disponibles** en un rango de fechas para elegir cuál alquilar. | 2 | US1.5 *(reutiliza la misma lógica, expuesta sin login)* | - Misma lógica de disponibilidad que US1.5 (no muestra vehículos con solapamiento de reserva/alquiler, ni en mantenimiento).<br>- No requiere ningún dato personal para buscar (es de lectura pública). |
| **US5.2** | Como cliente, quiero **crear una reserva completando mis datos básicos** (nombre, apellido, documento, email, teléfono) eligiendo un vehículo disponible y un rango de fechas, sin necesidad de registrarme. | 5 | US5.1, US2.1 *(reutiliza-o-crea cliente)*, US3.2 *(misma validación de disponibilidad)* | - Nombre, apellido, documento y una forma de contacto (email o teléfono) son obligatorios.<br>- Si ya existe un Cliente con ese documento, se reutiliza ese registro (no se duplica).<br>- Se aplican las mismas validaciones de disponibilidad que US3.2.<br>- Si el documento corresponde a un Cliente inactivo, se lo reactiva automáticamente (el cliente "vuelve") y se le asocia la reserva. |

*Subtotal E5: 7 puntos.*

*Fuera de alcance del MVP (a propósito, para no sobre-diseñar): que el cliente pueda ver o cancelar
sus propias reservas por sí mismo (requeriría algún mecanismo de identificación/login). Para
consultar o cancelar una reserva, el cliente contacta al empleado, que lo hace por él usando US3.3
y US3.4.*

---

## 5. Priorización (orden sugerido para desarrollar)

1. E1 — Gestión de Vehículos *(no depende de nada más, es la base)*
2. E2 — Gestión de Clientes *(independiente de E1)*
3. E3 — Gestión de Reservas *(depende de E1 y E2)*
4. **E5 — Autogestión de Reservas del Cliente** *(depende de E1 y E2/E3, reusa su lógica)*
5. E4 — Gestión de Alquileres *(depende de E1, E2 y, opcionalmente, E3)*

Las historias agregadas por el borrado lógico (US1.7, US2.5, US4.5) van al final de su épica:
dependen de que ya exista la baja (US1.4, US2.4) o el alquiler (US4.1).

## 6. Estimación (puntos de historia)

Estimación relativa en escala de Fibonacci (1-2-3-5-8), a criterio del equipo — sirve para
priorizar y planificar sprints en la Fase 6, no es una medida de tiempo exacta.

| Épica | Puntos |
|---|---|
| E1 — Gestión de Vehículos | 17 |
| E2 — Gestión de Clientes | 10 |
| E3 — Gestión de Reservas | 14 |
| E4 — Gestión de Alquileres | 15 |
| E5 — Autogestión de Reservas del Cliente | 7 |
| **Total** | **63** |

Las historias más grandes (5 puntos: US1.5, US3.2, US4.2, US5.2) comparten la parte más compleja
del dominio: la lógica de solapamiento de fechas y el cálculo de disponibilidad/monto. Conviene
resolverla bien una vez (en US1.5/US3.2) y reutilizarla en el resto, en vez de reimplementarla.

## 7. Dependencias entre historias

Cada tabla de historias (secciones E1-E5) tiene ahora una columna **"Depende de"** con el detalle
historia por historia. Como resumen, los dos tipos de dependencia que aparecen son:

- **Dependencias de flujo** (una historia necesita que otra ya funcione porque opera sobre datos
  que esa otra crea): p. ej. US3.1 depende de US1.1 y US2.1 (necesita que existan vehículos y
  clientes para poder reservarlos); US4.1 depende de US3.5 (una reserva confirmada) o puede
  hacerse directo; US4.2 depende de US4.1 (no se puede finalizar un alquiler que no empezó).
- **Dependencias de lógica reutilizada** (una historia reutiliza una regla de negocio ya resuelta
  en otra, en vez de reimplementarla): US3.2 y US5.1/US5.2 reutilizan la lógica de disponibilidad
  de US1.5; US1.4, US1.6 y US2.4 reutilizan el chequeo de "alquiler activo" que expone US4.1.

Esto también explica por qué E5 (Autogestión del Cliente) no puede arrancarse antes que E1 y E3: no
tiene datos ni reglas propias, es una fachada pública sobre la lógica de E1/E3.

## 8. User story map

Vista de las historias agrupadas por épica (columnas, en el orden de prioridad de la sección 5) y
ordenadas de arriba hacia abajo dentro de cada columna según la secuencia lógica de implementación.
Las flechas punteadas cruzando columnas marcan las dependencias de lógica reutilizada de la
sección 7 (no todas las dependencias de flujo están dibujadas, para no saturar el diagrama).

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'primaryColor': '#ffffff',
  'primaryBorderColor': '#4a4a4a',
  'primaryTextColor': '#1a1a1a',
  'lineColor': '#4a4a4a',
  'textColor': '#1a1a1a',
  'clusterBkg': '#eef6ff',
  'clusterBorder': '#2a6fb0'
}}}%%
flowchart LR
    subgraph E1["E1 — Vehículos (17 pts)"]
        direction TB
        US11["US1.1 Registrar · 3"]
        US12["US1.2 Listar · 2"]
        US13["US1.3 Modificar · 2"]
        US15["US1.5 Buscar disponibles · 5"]
        US14["US1.4 Dar de baja · 2"]
        US16["US1.6 Mantenimiento · 2"]
        US17["US1.7 Reactivar · 1"]
        US11 --> US12 --> US13
        US11 --> US15
        US11 --> US14
        US11 --> US16
        US14 --> US17
    end

    subgraph E2["E2 — Clientes (10 pts)"]
        direction TB
        US21["US2.1 Registrar · 3"]
        US22["US2.2 Buscar · 2"]
        US23["US2.3 Modificar · 2"]
        US24["US2.4 Desactivar · 2"]
        US25["US2.5 Reactivar · 1"]
        US21 --> US22 --> US23
        US21 --> US24 --> US25
    end

    subgraph E3["E3 — Reservas (14 pts)"]
        direction TB
        US31["US3.1 Crear reserva · 3"]
        US32["US3.2 Validar disponibilidad · 5"]
        US33["US3.3 Listar · 3"]
        US35["US3.5 Confirmar · 1"]
        US34["US3.4 Cancelar · 2"]
        US31 --> US32
        US31 --> US33
        US31 --> US35
        US31 --> US34
    end

    subgraph E5["E5 — Autogestión cliente (7 pts)"]
        direction TB
        US51["US5.1 Buscar (público) · 2"]
        US52["US5.2 Reservar (público) · 5"]
        US51 --> US52
    end

    subgraph E4["E4 — Alquileres (15 pts)"]
        direction TB
        US41["US4.1 Iniciar alquiler · 3"]
        US42["US4.2 Finalizar alquiler · 5"]
        US43["US4.3 Listar · 2"]
        US44["US4.4 Historial cliente · 3"]
        US45["US4.5 Anular · 2"]
        US41 --> US42 --> US43
        US42 --> US44
        US41 --> US45
    end

    US15 -.reutiliza.-> US32
    US15 -.reutiliza.-> US51
    US21 -.reutiliza.-> US52
    US32 -.reutiliza.-> US52
    US41 -.expone chequeo.-> US14
    US41 -.expone chequeo.-> US16
    US41 -.expone chequeo.-> US24

    style E1 fill:#eef6ff,stroke:#2a6fb0,color:#1a1a1a
    style E2 fill:#f3eaff,stroke:#7e3ff2,color:#1a1a1a
    style E3 fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    style E5 fill:#eafaf0,stroke:#2f9e5c,color:#1a1a1a
    style E4 fill:#fdeaea,stroke:#c0392b,color:#1a1a1a

    classDef story fill:#ffffff,stroke:#4a4a4a,color:#1a1a1a
    class US11,US12,US13,US15,US14,US16,US17,US21,US22,US23,US24,US25,US31,US32,US33,US35,US34,US51,US52,US41,US42,US43,US44,US45 story
```

## 9. Qué falta validar antes de pasar a la Fase 2

- [x] ¿Están de acuerdo el problema/objetivo del punto 1 y 2? → **Sí, confirmado.**
- [x] ¿El actor único "Empleado" es correcto, o la empresa quiere autogestión de clientes? →
      **Se confirmó autogestión de clientes, sin cuenta/login** — el cliente completa datos
      básicos obligatorios en cada reserva (E5).
- [x] ¿Están bien las épicas/historias nuevas (US1.6, US4.4, E5)? → **Sí, confirmado.**
- [x] ¿Login para Empleado y/o Cliente? → **No, no se maneja seguridad en el MVP.**

- [ ] ¿Borrado lógico (US1.4, US2.4 y US5.2 ajustadas; US1.7, US2.5 y US4.5 nuevas)? → Agregado
      después del cierre a pedido del equipo (ver `docs/cambios/01-borrado-logico.md`);
      **pendiente de validar**.

**Fase 1 cerrada** (con el cambio de borrado lógico pendiente de validar). Se pasa a la Fase 2 (Requerimientos funcionales y no funcionales) en
`docs/02-requerimientos.md`.
