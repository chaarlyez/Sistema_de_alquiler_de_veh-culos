# Fase 5 — Mockup / Prototipo: división del trabajo

La Fase 5 se divide en 3 partes, una por integrante, siguiendo la misma agrupación por épicas que
se usó en las Fases 3 y 4 (`docs/03-uml/00-asignacion.md`, `docs/04-base-de-datos/00-asignacion.md`)
para mantener a cada integrante dueño de las mismas funcionalidades de punta a punta: quien modeló
una clase en UML y la pasó a tabla, diseña acá las pantallas que la usan.

**Alcance de la fase**: se prototipan las pantallas del **back-office del empleado** (vehículos,
clientes, reservas, alquileres) y el **formulario público de reserva del cliente**. El MVP solo
exige UI para el formulario público (ver `CLAUDE.md` sección 4); el back-office se prototipa igual
para validar los flujos y la navegación antes de programar. Si en la Fase 6 el back-office se
construye con UI o queda solo como API REST se decide recién al arrancar esa fase — el prototipo
sirve en los dos casos (en el segundo, como referencia de qué datos y validaciones expone cada
endpoint).

## Qué entrega cada parte

Para cada pantalla de su alcance:

1. **Mockup navegable** en HTML + CSS, sin frameworks ni backend: datos de ejemplo escritos a mano
   y navegación con links entre pantallas. JavaScript solo si hace falta de verdad (ej. mostrar un
   modal de confirmación); se puede evitar mostrando el modal como pantalla aparte.
2. **Descripción de la pantalla** en su `.md`: objetivo, historias y RF que cubre, campos (cuáles
   son obligatorios), acciones/botones y a dónde lleva cada uno, y los **mensajes de error** de las
   reglas de negocio que aplican (RNF01: el mensaje dice qué campo o regla falló).
3. **Estados especiales** como pantalla o variante aparte: listado vacío, error de validación,
   confirmación de acciones de baja/cancelación/anulación (RN15: nunca dice "eliminar").
4. **Diagrama de navegación de su parte** (Mermaid `flowchart`), embebido en el `.md` y con su
   fuente editable `.mmd` en `docs/05-mockups/fuentes/` — misma regla que en la Fase 3: si se
   cambia el diagrama, se actualizan la fuente y el bloque embebido en el mismo commit.
5. Sección final **"Qué falta validar"** con checklist, igual que en las fases anteriores.

## Base común (antes de dividir)

Para que las 3 partes encajen sin retrabajo al integrar:

- **Archivos**: cada parte escribe su documento `docs/05-mockups/0N-<integrante>-<tema>.md` y sus
  pantallas en `docs/05-mockups/prototipo/`, con nombres `<seccion>-<pantalla>.html` en minúscula
  y con guiones (ej. `vehiculos-listado.html`, `reserva-publica-datos.html`).
- **Estilos**: un único `prototipo/estilos.css` compartido y una `prototipo/plantilla.html` con el
  layout del back-office (encabezado + menú lateral con Vehículos, Clientes, Reservas, Alquileres).
  Los arma la Parte 3 **primero** (es chico); mientras tanto las Partes 1 y 2 pueden empezar por
  la descripción de pantallas y el diagrama de navegación.
- **Patrones de pantalla** del back-office, iguales en las 4 secciones:
  - *Listado*: filtros arriba, tabla, botón "Nuevo …" y acciones por fila. Los registros dados de
    baja (Retirado, inactivo, Cancelada, Anulado) no aparecen por defecto; se ven con el filtro de
    estado (RF47, RF50, RF40).
  - *Formulario* de alta/edición: obligatorios marcados con `*`, error debajo del campo que falló.
  - *Confirmación* antes de cualquier baja, cancelación o anulación, explicando qué pasa con el
    historial.
- **Textos de la UI en español** (son para el usuario final). Los nombres de estados se muestran
  en español (Disponible, Pendiente, Activo…), no los valores del enum de la base.
- **Datos de ejemplo**: los de `docs/04-base-de-datos/sql/02-dml.sql`, para que los mockups sean
  coherentes entre sí y con la base (misma patente, mismos clientes, mismos montos).

## Parte 1 — Johann-Tafur

**Alcance**: E1 Vehículos + E2 Clientes (back-office).

Vehículos:
- Listado con filtro por estado, incluido Retirado (US1.2, RF47).
- Alta y edición de vehículo (US1.1, US1.3): error de patente duplicada; si la patente es de un
  vehículo Retirado, el mensaje lo indica y ofrece reactivarlo (US1.7).
- Acciones de estado desde el listado o el detalle: marcar/desmarcar mantenimiento (US1.6), dar de
  baja (US1.4) y reactivar (US1.7). Mostrar los bloqueos: no se puede dar de baja ni mandar a
  mantenimiento con un alquiler activo, ni dar de baja con reservas Pendientes o Confirmadas.
- Búsqueda de disponibles por rango de fechas (US1.5), con el estado "no hay unidades disponibles".

Clientes:
- Búsqueda por documento o apellido, con opción de incluir inactivos (US2.2, RF50).
- Alta y edición de cliente (US2.1, US2.3): error de documento duplicado; si es de un cliente
  inactivo, ofrecer reactivarlo.
- Desactivar (US2.4), con el bloqueo por reservas o alquileres activos, y reactivar (US2.5).

## Parte 2 — chaarlyez

**Alcance**: E3 Reservas (back-office) + E5 Autogestión de Reservas del Cliente (formulario
público — **la única UI obligatoria del MVP**).

Reservas (back-office):
- Listado con filtros por cliente, vehículo y estado (US3.3).
- Crear reserva (US3.1, US3.2): elegir un cliente activo y un vehículo no Retirado, fechas de
  inicio y fin. Errores: fecha de fin no posterior a la de inicio, y solapamiento con otra reserva
  o con un alquiler activo (RN12, RN14), con un mensaje que diga cuál es el conflicto.
- Confirmar una reserva Pendiente (US3.5) y cancelar (US3.4), con el bloqueo si ya derivó en
  alquiler.

Formulario público (sin login, sin el menú del back-office — layout propio y más simple):
- Paso 1: buscar vehículos disponibles por rango de fechas, sin pedir datos personales (US5.1).
- Paso 2: elegir un vehículo y completar los datos (US5.2): nombre, apellido, documento y al menos
  email o teléfono obligatorios.
- Paso 3: comprobante de la reserva creada (queda Pendiente), aclarando que para consultarla o
  cancelarla hay que contactar a la empresa (no hay autogestión de cancelación en el MVP).
- Errores: sin vehículos disponibles, campos faltantes, y el vehículo dejó de estar disponible
  entre el paso 1 y el envío (otra persona lo reservó).
- Ojo de privacidad: el formulario **no debe revelar** si el documento ya estaba registrado ni si
  el cliente estaba inactivo; la reutilización o reactivación del cliente (RN10) es invisible
  para quien completa el formulario.

## Parte 3 — mariocardona970546

**Alcance**: E4 Alquileres (back-office) + base común + integración final del prototipo.

Base común (primero, ver arriba): `prototipo/estilos.css` y `prototipo/plantilla.html`.

Alquileres:
- Listado de activos, finalizados y anulados, con los anulados ocultos por defecto (US4.3, RF40).
- Iniciar alquiler (US4.1): desde una reserva Confirmada o directo, eligiendo cliente y vehículo.
  Bloqueos: vehículo Alquilado o Retirado, cliente inactivo (RF36, RF54).
- Finalizar alquiler (US4.2): fecha **y hora** real de devolución; mostrar los días efectivos y el
  monto calculado (RN13, tolerancia de 1 hora) antes de confirmar, y elegir si el vehículo vuelve a
  Disponible o a Mantenimiento (RF39).
- Historial de alquileres de un cliente por documento, aunque el cliente o el vehículo estén dados
  de baja (US4.4, RF41).
- Anular un alquiler Activo (US4.5), avisando en la confirmación que el vehículo vuelve a
  Disponible y que, si venía de una reserva, esa reserva pasa a Cancelada (RF56).

**Integración final**:
- `prototipo/index.html` como punto de entrada: menú del back-office enlazando las 4 secciones y
  un link aparte al formulario público.
- Revisar que las pantallas de las 3 partes usen la plantilla, los estilos y los patrones comunes,
  y que los links entre secciones funcionen (ej. de una reserva Confirmada a "Iniciar alquiler", o
  del detalle de un cliente a su historial).
- **Diagrama de navegación completo** del sistema, uniendo los de las 3 partes (igual mecánica que
  el diagrama de clases integrado de la Fase 3 y el ER de la Fase 4).

## Notas

- Nivel junior: mockups simples y legibles, sin animaciones ni librerías. Lo que importa es que
  muestren los datos, las validaciones y el flujo correctos, no el diseño visual fino.
- El prototipo no implementa lógica: los mensajes de error se muestran como ejemplos estáticos.
  Las reglas siguen definidas en `docs/02-requerimientos.md`; si al diseñar una pantalla aparece
  una regla que falta o se contradice, se anota en el `.md` de la parte y se resuelve en la
  revisión de integración, sin reabrir las fases cerradas.
- Al terminar las 3 partes se arma `04-revision-integracion.md`, igual que en las Fases 3 y 4
  (coherencia de nombres de campos, estados, mensajes y navegación entre las partes).
