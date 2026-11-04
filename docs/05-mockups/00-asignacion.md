# Fase 5 — Mockup / Prototipo: división del trabajo

La Fase 5 se divide en 3 partes, una por integrante, siguiendo la misma agrupación por épicas que
se usó en las Fases 3 y 4 (`docs/03-uml/00-asignacion.md`, `docs/04-base-de-datos/00-asignacion.md`)
para mantener a cada integrante dueño de las mismas funcionalidades de punta a punta: quien modeló
una clase en UML y la pasó a tabla, diseña acá las pantallas que la usan.

**Alcance de la fase**: se prototipan las pantallas del **back-office del empleado** (vehículos,
clientes, reservas, alquileres) y el **formulario público de reserva del cliente**, cada una en
versión **web (escritorio) y móvil**. El MVP solo exige UI para el formulario público (ver
`CLAUDE.md` sección 4); el back-office se prototipa igual para validar los flujos y la navegación
antes de programar. Si en la Fase 6 el back-office se construye con UI o queda solo como API REST
se decide recién al arrancar esa fase — el prototipo sirve en los dos casos (en el segundo, como
referencia de qué datos y validaciones expone cada endpoint).

## 1. Web y móvil

Cada pantalla es **un solo archivo HTML responsive** que se adapta al ancho de la pantalla, no dos
mockups separados: así no hay dos versiones que mantener sincronizadas, y es como se construiría
en la Fase 6. Los estilos son *mobile first* (primero para celular, y un único corte en **768 px**
para escritorio), y ya están resueltos en `prototipo/estilos.css`:

| Elemento | Móvil (< 768 px) | Web (≥ 768 px) |
|---|---|---|
| Menú del back-office | Fila de pestañas arriba, desplazable de costado | Columna lateral fija a la izquierda |
| Listados (`.tabla`) | Cada fila se ve como una tarjeta, un dato por renglón | Tabla normal |
| Filtros y botones | Uno debajo del otro, a lo ancho | En fila |
| Formulario público | Una columna (es el uso principal: el cliente reserva desde el celular) | La misma columna, centrada |

Cada pantalla se revisa en los **dos tamaños de referencia**: **375 px** (celular) y **1280 px**
(escritorio). Con el navegador alcanza: F12 → botón de "modo dispositivo" (Ctrl+Shift+M en
Chrome/Firefox) → elegir un celular, o escribir el ancho a mano.

Reglas para que el responsive funcione sin tocar CSS:
- Copiar siempre una de las plantillas (traen la etiqueta `<meta name="viewport">`, sin la cual
  el celular muestra la página achicada).
- En los listados, **todas** las celdas `<td>` llevan `data-label="Nombre de la columna"`: en el
  celular ese texto es el que aparece al lado de cada dato.
- No poner anchos fijos en píxeles ni estilos dentro del HTML (`style="..."`).

## 2. Qué entrega cada parte

Para cada pantalla de su alcance:

1. **Mockup navegable** en HTML + CSS, sin frameworks ni backend: datos de ejemplo escritos a mano
   y navegación con links entre pantallas. JavaScript solo si hace falta de verdad; un modal de
   confirmación se resuelve como pantalla aparte.
2. **Descripción de la pantalla** en su `.md`: objetivo, historias y RF que cubre, campos (cuáles
   son obligatorios), acciones/botones y a dónde lleva cada uno, y los **mensajes de error** de las
   reglas de negocio que aplican (RNF01: el mensaje dice qué campo o regla falló).
3. **Versión móvil** revisada: en la descripción, una línea con lo que cambia en el celular (si es
   solo lo que resuelve `estilos.css`, alcanza con decir "estándar"), y dos capturas por pantalla
   principal (375 px y 1280 px) en `docs/05-mockups/capturas/`, con el nombre de la pantalla y el
   sufijo `-movil.png` / `-web.png`.
4. **Estados especiales** como pantalla o variante aparte: listado vacío, error de validación,
   confirmación de acciones de baja/cancelación/anulación (RN15: nunca dice "eliminar").
5. **Diagrama de navegación de su parte** (Mermaid `flowchart`), embebido en el `.md` y con su
   fuente editable `.mmd` en `docs/05-mockups/fuentes/` — misma regla que en la Fase 3: si se
   cambia el diagrama, se actualizan la fuente y el bloque embebido en el mismo commit.
6. Sección final **"Qué falta validar"** con checklist, igual que en las fases anteriores.

## 3. Base común (ya creada)

La base común la armó chaarlyez antes de repartir el trabajo, para que cada integrante pueda
arrancar su parte apenas llegue sin esperar a nadie. Está en `docs/05-mockups/prototipo/`:

| Archivo | Para qué |
|---|---|
| `estilos.css` | Estilos compartidos por todas las pantallas, ya responsive (sección 1). |
| `plantilla.html` | Layout del back-office (encabezado + menú) con un ejemplo de cada patrón común: listado, formulario con error y confirmación de baja. Se copia para cada pantalla nueva. |
| `plantilla-publica.html` | Layout del formulario público: sin menú, con indicador de pasos. |
| `index.html` | Punto de entrada del prototipo, con links a la pantalla de entrada de cada sección. |

Patrones de pantalla del back-office, iguales en las 4 secciones (ver el ejemplo en
`plantilla.html`):
- *Listado*: título con botón "Nuevo …", filtros arriba, tabla y acciones por fila. Los
  registros dados de baja (Retirado, inactivo, Cancelada, Anulado) no aparecen por defecto; se
  ven con el filtro de estado (RF47, RF50, RF40).
- *Formulario* de alta/edición: obligatorios marcados con `*`, aviso general arriba y error
  debajo del campo que falló.
- *Confirmación* antes de cualquier baja, cancelación o anulación, explicando qué pasa con el
  historial.

Otras convenciones:
- **Textos de la UI en español** (son para el usuario final). Los estados se muestran en español
  (Disponible, Pendiente, Activo…), no con los valores del enum de la base. Colores de estado:
  `estado ok` (verde), `estado espera` (amarillo), `estado baja` (gris).
- **Datos de ejemplo**: los de `docs/04-base-de-datos/sql/02-dml.sql`, para que los mockups sean
  coherentes entre sí y con la base (mismas patentes, mismos clientes, mismos montos).
- **Nombres de archivo**: `<seccion>-<pantalla>.html`, en minúscula y con guiones (ej.
  `vehiculos-alta.html`, `reservas-cancelar.html`). Las **pantallas de entrada** de cada sección
  tienen nombre fijo, porque las enlazan el menú y el `index.html`:

  | Pantalla de entrada | Parte |
  |---|---|
  | `vehiculos-listado.html`, `clientes-listado.html` | 1 |
  | `reservas-listado.html`, `reserva-publica-buscar.html` | 2 |
  | `alquileres-listado.html` | 3 |

  También tienen nombre fijo las pantallas que se enlazan desde otra parte:
  `alquileres-iniciar.html` (desde una reserva Confirmada, Parte 2) y
  `alquileres-historial.html` (desde un cliente, Parte 1).

## 4. Organización del equipo

Las 3 partes son independientes entre sí (cada una tiene sus propios archivos), así que cada
integrante arranca cuando llega, sin esperar a los demás. Solo la integración final (Parte 3) y la
revisión de integración necesitan las 3 partes terminadas.

**Orden de trabajo**:

1. **chaarlyez** — base común (hecha) y arranca su Parte 2.
2. **Johann-Tafur y mariocardona970546**, cuando lleguen: actualizar `main`, crear su rama,
   leer este documento y `plantilla.html`, y arrancar su parte. Johann-Tafur tiene además
   pendiente validar el cambio 01 de borrado lógico (checklist en la sección 7 de
   `docs/cambios/01-borrado-logico.md`) — conviene hacerlo primero, porque los bloqueos y las
   reactivaciones que diseña en sus pantallas salen de ese cambio.
3. **mariocardona970546** — integración final, cuando las 3 partes estén en `main`.
4. **Todos** — revisión de integración (`04-revision-integracion.md`) y cierre de la fase.

**Cómo arrancar** (cada integrante, en su máquina):

```bash
git switch main
git pull
git switch -c <integrante>-fase5-mockups
```

Con `<integrante>` = `chaarlyez`, `johann-tafur` o `mariocardona970546`. Al terminar, se sube la
rama y se abre un Pull Request a `main`.

**Qué archivos toca cada uno**, para no pisarse:

| Integrante | Archivos propios |
|---|---|
| Johann-Tafur | `01-johann-tafur-vehiculos-clientes.md`, `prototipo/vehiculos-*.html`, `prototipo/clientes-*.html`, sus `.mmd` y capturas |
| chaarlyez | `02-chaarlyez-reservas.md`, `prototipo/reservas-*.html`, `prototipo/reserva-publica-*.html`, sus `.mmd` y capturas |
| mariocardona970546 | `03-mariocardona970546-alquileres.md`, `prototipo/alquileres-*.html`, sus `.mmd` y capturas, `prototipo/index.html` |

Archivos compartidos:
- `prototipo/estilos.css`: si hace falta un estilo nuevo, **se agrega al final** (no se cambian
  los que ya existen, porque los usan las pantallas de los demás) y se avisa en el PR.
- `fuentes/README.md`: cada uno completa solo la sección de su parte.

## 5. Parte 1 — Johann-Tafur

**Alcance**: E1 Vehículos + E2 Clientes (back-office).

Vehículos:
- Listado con filtro por estado, incluido Retirado (US1.2, RF47) — `vehiculos-listado.html`.
- Alta y edición de vehículo (US1.1, US1.3): error de patente duplicada; si la patente es de un
  vehículo Retirado, el mensaje lo indica y ofrece reactivarlo (US1.7).
- Acciones de estado desde el listado o el detalle: marcar/desmarcar mantenimiento (US1.6), dar de
  baja (US1.4) y reactivar (US1.7). Mostrar los bloqueos: no se puede dar de baja ni mandar a
  mantenimiento con un alquiler activo, ni dar de baja con reservas Pendientes o Confirmadas.
- Búsqueda de disponibles por rango de fechas (US1.5), con el estado "no hay unidades disponibles".

Clientes:
- Búsqueda por documento o apellido, con opción de incluir inactivos (US2.2, RF50) —
  `clientes-listado.html`.
- Alta y edición de cliente (US2.1, US2.3): error de documento duplicado; si es de un cliente
  inactivo, ofrecer reactivarlo.
- Desactivar (US2.4), con el bloqueo por reservas o alquileres activos, y reactivar (US2.5).
- Desde el cliente, un link a su historial de alquileres (`alquileres-historial.html`, Parte 3).

## 6. Parte 2 — chaarlyez

**Alcance**: base común (hecha, sección 3) + E3 Reservas (back-office) + E5 Autogestión de
Reservas del Cliente (formulario público — **la única UI obligatoria del MVP**).

Reservas (back-office):
- Listado con filtros por cliente, vehículo y estado (US3.3) — `reservas-listado.html`.
- Crear reserva (US3.1, US3.2): elegir un cliente activo y un vehículo no Retirado, fechas de
  inicio y fin. Errores: fecha de fin no posterior a la de inicio, y solapamiento con otra reserva
  o con un alquiler activo (RN12, RN14), con un mensaje que diga cuál es el conflicto.
- Confirmar una reserva Pendiente (US3.5) y cancelar (US3.4), con el bloqueo si ya derivó en
  alquiler.
- Desde una reserva Confirmada, un link a "Iniciar alquiler" (`alquileres-iniciar.html`, Parte 3).

Formulario público (sin login, con `plantilla-publica.html`):
- Paso 1: buscar vehículos disponibles por rango de fechas, sin pedir datos personales (US5.1) —
  `reserva-publica-buscar.html`.
- Paso 2: elegir un vehículo y completar los datos (US5.2): nombre, apellido, documento y al menos
  email o teléfono obligatorios.
- Paso 3: comprobante de la reserva creada (queda Pendiente), aclarando que para consultarla o
  cancelarla hay que contactar a la empresa (no hay autogestión de cancelación en el MVP).
- Errores: sin vehículos disponibles, campos faltantes, y el vehículo dejó de estar disponible
  entre el paso 1 y el envío (otra persona lo reservó).
- Ojo de privacidad: el formulario **no debe revelar** si el documento ya estaba registrado ni si
  el cliente estaba inactivo; la reutilización o reactivación del cliente (RN10) es invisible
  para quien completa el formulario.
- En móvil es donde más se usa: revisar que los campos de fecha, documento y teléfono sean
  cómodos de completar en 375 px (tipo de campo `date`, `tel`, `email` según corresponda).

## 7. Parte 3 — mariocardona970546

**Alcance**: E4 Alquileres (back-office) + integración final del prototipo.

Alquileres:
- Listado de activos, finalizados y anulados, con los anulados ocultos por defecto (US4.3, RF40)
  — `alquileres-listado.html`.
- Iniciar alquiler (US4.1) — `alquileres-iniciar.html`: desde una reserva Confirmada o directo,
  eligiendo cliente y vehículo. Bloqueos: vehículo Alquilado o Retirado, cliente inactivo (RF36,
  RF54).
- Finalizar alquiler (US4.2): fecha **y hora** real de devolución; mostrar los días efectivos y el
  monto calculado (RN13, tolerancia de 1 hora) antes de confirmar, y elegir si el vehículo vuelve a
  Disponible o a Mantenimiento (RF39).
- Historial de alquileres de un cliente por documento, aunque el cliente o el vehículo estén dados
  de baja (US4.4, RF41) — `alquileres-historial.html`.
- Anular un alquiler Activo (US4.5), avisando en la confirmación que el vehículo vuelve a
  Disponible y que, si venía de una reserva, esa reserva pasa a Cancelada (RF56).

**Integración final** (cuando las 3 partes estén en `main`):
- Completar `prototipo/index.html` si hace falta y revisar que todas las pantallas usen las
  plantillas, los estilos y los patrones comunes.
- Recorrer el prototipo entero en 375 px y en 1280 px, revisando que los links entre secciones
  funcionen (ej. de una reserva Confirmada a "Iniciar alquiler", o de un cliente a su historial).
- **Diagrama de navegación completo** del sistema, uniendo los de las 3 partes (igual mecánica que
  el diagrama de clases integrado de la Fase 3 y el ER de la Fase 4).

## 8. Notas

- Nivel junior: mockups simples y legibles, sin animaciones ni librerías. Lo que importa es que
  muestren los datos, las validaciones y el flujo correctos en los dos tamaños, no el diseño
  visual fino.
- El prototipo no implementa lógica: los mensajes de error se muestran como ejemplos estáticos.
  Las reglas siguen definidas en `docs/02-requerimientos.md`; si al diseñar una pantalla aparece
  una regla que falta o se contradice, se anota en el `.md` de la parte y se resuelve en la
  revisión de integración, sin reabrir las fases cerradas.
- Al terminar las 3 partes se arma `04-revision-integracion.md`, igual que en las Fases 3 y 4
  (coherencia de nombres de campos, estados, mensajes, navegación y versión móvil entre las
  partes).
