# Fase 5 — Revisión de coherencia entre las 3 partes

> **Borrador para validar en equipo.** Lo preparó mariocardona970546 como parte de la integración
> final. La Fase 5 se cierra cuando los 3 integrantes confirmen la sección 5.

Revisión de los 3 documentos entregados y del prototipo completo (50 pantallas):
`01-johann-tafur-vehiculos-clientes.md` (Parte 1), `02-chaarlyez-reservas.md` (Parte 2) y
`03-mariocardona970546-alquileres.md` (Parte 3, que incluye la integración final).

## 1. Qué se verificó

| # | Revisión | Resultado |
|---|---|---|
| 1 | **Datos de ejemplo**: patentes, vehículos, clientes, documentos y precios coinciden entre las partes y con `02-dml.sql`. Valentina Ruiz (DNI 40333444) es la clienta agregada por la Parte 2 y se reutiliza en la Parte 3. | ✅ Coherente |
| 2 | **Estados**: se muestran en español, sin valores del enum de la base, y con el mismo color en todas las pantallas. *Activo* es verde en un cliente y ámbar en un alquiler a propósito, como define `estilos.css`. | ✅ Coherente |
| 3 | **Borrado lógico (RN15)**: ninguna acción ofrece "eliminar". Las confirmaciones explican qué pasa con el historial. | ✅ Coherente |
| 4 | **Filtros de los listados**: los registros dados de baja se ocultan por defecto en las 4 secciones y se pueden consultar. | ✅ Coherente |
| 5 | **Links**: ninguno de los links de las 50 pantallas lleva a un archivo inexistente, incluidos los cruces entre partes. | ✅ Coherente |
| 6 | **Menú**: en las pantallas del back-office, la sección marcada coincide con la pantalla. | ✅ Coherente |
| 7 | **Web y móvil**: las 50 pantallas se abrieron en 375 px y 1280 px, y ninguna se desborda hacia el costado. Es una revisión automática de ancho; la revisión visual de cada integrante queda en la sección 5. | ✅ Sin desbordes |
| 8 | **Formularios**: se probaron 8 formularios con datos vacíos o inválidos, y todos muestran el error sin pasar de pantalla. | ✅ Coherente |
| 9 | **Diagramas**: las fuentes `.mmd` de las Partes 1 y 3 y de la navegación completa coinciden con sus bloques embebidos. | ✅ Coherente |

## 2. Correcciones aplicadas

- **Validación en la Parte 1**: `vehiculos-alta`, `clientes-alta` y `vehiculos-disponibilidad` usan
  `validacion.js`, como pide la guía de estilo.
- **Links de la Parte 1**: *Reservar* desde la disponibilidad lleva a `reservas-nueva.html`, y el
  historial de Diego Ramírez lleva a `alquileres-historial-vacio.html`. Se actualizaron también su
  descripción y su diagrama (`.md` y `.mmd`).
- **`index.html`**: se quitó una sección repetida y se agregaron 4 recorridos guiados.
- **Capturas de la Parte 3**: rehechas con el tema VeloRent.
- **Comentario de `alquileres-finalizar-confirmar.html`**: una devolución a las 12:00 con retiro a
  las 10:00 está 2 horas después del período, no 1 h 20 min.

## 3. Observación sobre una fase cerrada (no bloqueante)

El criterio de aceptación de **RF38** en `docs/02-requerimientos.md` dice que devolver a las 12:00
un vehículo retirado a las 10:00 es "1h20 tarde". Son **2 horas**. El resultado del criterio no
cambia (se cobra un día adicional), así que no se reabre la Fase 2; conviene corregir el texto si
el equipo vuelve a tocar ese documento.

## 4. Decisiones pendientes

Las propuestas son un punto de partida para decidir rápido; ninguna está aplicada todavía.

### Antes de cerrar la Fase 5

| # | Tema | Propuesta | Decisión |
|---|---|---|---|
| 1 | **Nombre en los encabezados**: la página de inicio dice "VeloRent" y el resto "Alquiler de Vehículos". | Usar uno solo en todas las pantallas. | |
| 2 | **`inicio.html`** tiene estilos dentro del HTML y muestra vehículos que no están en `02-dml.sql`. | Pasar los estilos a `estilos.css` y mostrar los vehículos de los datos de ejemplo. | |
| 3 | **Capturas de la Parte 1**: faltan las de sus pantallas principales (`00-asignacion.md`, sección 2). | Johann-Tafur las agrega, o las toma quien integra. | |

### Reglas para definir antes de programar (Fase 6)

| # | Tema | Propuesta | Decisión |
|---|---|---|---|
| 4 | **Alquiler directo de un vehículo con reserva de otro cliente**: ninguna regla lo impide, y como el alquiler no tiene fecha de fin, el vehículo podría no volver a tiempo. | Mostrar una advertencia con la próxima reserva y exigir que el empleado confirme. | |
| 5 | **Alquilar un vehículo en mantenimiento**: tampoco hay regla. | Bloquearlo: en mantenimiento no está disponible (US1.6). | |
| 6 | **Reservar un vehículo en mantenimiento** desde el back-office: el mockup lo permite, pero la búsqueda de disponibles no lo muestra. | Permitirlo solo al empleado, para fechas posteriores al service. | |
| 7 | **Devolución antes de 24 horas**: RN13 no lo define. | Cobrar un día como mínimo. | |
| 8 | **Retiro en una fecha distinta a la reservada**. | Permitirlo: la fecha real de retiro es la que se factura. | |
| 9 | **Reservas con fecha pasada**: RF26 solo compara el fin contra el inicio. | Rechazar un inicio anterior a hoy. | |
| 10 | **Reservas Pendientes vencidas**: ninguna regla dice qué pasa con ellas. | En el MVP, las cancela el empleado a mano. | |
| 11 | **Formato del documento**: no hay regla. | Solo números, como ya valida el mockup. | |
| 12 | **Cliente creado aunque falle la reserva pública**. | Crear o reactivar el cliente y guardar la reserva en una sola transacción. | |

## 5. Validación del equipo

- [ ] **Johann-Tafur**: revisó las correcciones sobre sus pantallas (sección 2) y el prototipo en
      375 px y 1280 px.
- [ ] **chaarlyez**: revisó que su parte siga igual y el prototipo en 375 px y 1280 px.
- [ ] **mariocardona970546**: revisó el prototipo en 375 px y 1280 px.
- [ ] Decisiones 1 a 3 resueltas.
- [ ] Decisiones 4 a 12 resueltas, o acordado resolverlas al arrancar la Fase 6.

**Fase 5: pendiente de cierre.**
