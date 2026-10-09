# Cambio 01 — Borrado lógico de vehículos, clientes, reservas y alquileres

| Dato | Valor |
|---|---|
| Fecha | 2026-10-08 |
| Pedido por | chaarlyez (en nombre del equipo) |
| Fases afectadas | 1, 2, 3 y 4 (ya cerradas) |
| Estado | Documentado en las 4 fases — **pendiente de validar por el equipo** |

## 1. Qué se pidió

1. Poder **deshabilitar clientes**.
2. Poder **hacer cancelaciones**.
3. Poder **dar de baja los vehículos** que salen de la flota y no se van a volver a alquilar.
4. Que haya opciones para "borrar" cualquier dato, pero que **los datos no se eliminen sino que
   se oculten**, para poder volver a usarlos si el registro regresa (por ejemplo, un cliente que se
   dio de baja y vuelve a reservar).

## 2. Problema que había en el diseño original

- "Dar de baja un vehículo" (US1.4) y "eliminar un cliente" (US2.4) estaban pensados como un borrado
  físico, pero en la base de datos no existía un estado de baja (`vehicles.status` solo admitía
  `AVAILABLE`, `RENTED` y `MAINTENANCE`), así que la única forma de hacerlo era un `DELETE`.
- `reservations` y `rentals` tienen FKs hacia `vehicles` y `customers`. Si un vehículo o cliente
  tenía historial, aunque fuera un alquiler ya `FINISHED`, PostgreSQL **rechazaba el `DELETE`**.
  Pero RN08 solo bloqueaba la baja cuando había actividad *activa*, así que la regla de negocio y el
  esquema se contradecían.
- Aunque el borrado hubiera funcionado, se habría perdido el historial de alquileres y montos
  cobrados (US4.4).

## 3. Decisión: borrado lógico (RN15)

Ningún registro se elimina físicamente. Cada entidad tiene su forma de "borrar" que oculta el dato
y conserva el historial:

| Entidad | "Borrar" significa | Columna en la BD | ¿Se puede revertir? |
|---|---|---|---|
| Vehículo | Pasar a estado **Retirado** (vendido, siniestrado, fin de vida útil) | `vehicles.status = 'RETIRED'` + `deactivated_at` | Sí: "Reactivar vehículo" (US1.7) lo vuelve a Disponible |
| Cliente | Quedar **inactivo** | `customers.active = FALSE` + `deactivated_at` | Sí: lo reactiva el empleado (US2.5), o se reactiva solo si vuelve a reservar por el formulario público (RF58) |
| Reserva | Pasar a **Cancelada** (ya existía) | `reservations.status = 'CANCELLED'` | No: si el cliente cambia de idea, se crea una reserva nueva |
| Alquiler | Pasar a **Anulado** (solo si se registró por error) | `rentals.status = 'VOIDED'` | No: un alquiler anulado queda como constancia del error |

Por qué así (análisis del negocio):
- **Así trabajan las empresas reales**: un vehículo vendido o siniestrado se marca "fuera de flota"
  (de-fleet) y no se borra, porque su historial de uso e ingresos sigue siendo necesario. Un
  contrato de alquiler emitido por error se anula, no se borra, para que la auditoría quede
  completa.
- **El historial sigue siendo verdadero**: US4.4 (historial de un cliente) y los montos cobrados
  siguen siendo consultables aunque el cliente o el vehículo estén dados de baja.
- **Los datos se pueden reutilizar**: patente y documento siguen siendo únicos (RN16). Si vuelve un
  cliente o un vehículo, se reactiva el registro existente en lugar de cargarlo de nuevo (y no
  quedan duplicados).
- **Es simple de implementar (nivel junior)**: una columna de estado o un booleano más una fecha de
  baja. Sin tablas de auditoría ni librerías extra.

**Anular vs. finalizar un alquiler**: finalizar es la devolución normal y calcula el monto. Anular
solo existe para corregir un alquiler que nunca debió registrarse (el cliente no se llevó el auto,
se eligió mal la unidad). Un alquiler `FINISHED` no se puede anular, porque ya se cobró.

## 4. Impacto en cada fase

| Fase | Documento | Cambios |
|---|---|---|
| 1 | `docs/01-epicas-historias-usuario.md` | US1.4 y US2.4 reformuladas como bajas lógicas; US1.2, US2.1, US2.2, US3.1, US3.4, US4.1, US4.3, US4.4 y US5.2 con criterios ajustados; **nuevas US1.7** (reactivar vehículo, 1 pt), **US2.5** (reactivar cliente, 1 pt) y **US4.5** (anular alquiler, 2 pts). Total: 59 → 63 puntos, 21 → 24 historias. |
| 2 | `docs/02-requerimientos.md` | **Nuevos RF46-RF58**, **RNF09** (trazabilidad) y **RN15-RN18**; ajustados RF10, RF23, RF24, RF27, RF40, RF41, RN01, RN08 y RN10; nuevos criterios Given/When/Then y matriz de trazabilidad actualizada. Se numeró a continuación (sin renumerar) para no romper referencias de las Fases 3 y 4. |
| 3 | `docs/03-uml/` | Parte 1: casos de uso de reactivación, `EstadoVehiculo.RETIRADO`, `Cliente.activo`, `fechaBaja`, rechazo por patente/documento dado de baja, **nuevos** diagramas de estados de `Cliente` y de actividades de baja de vehículo. Parte 2: reactivación automática en la reserva pública, exclusión de vehículos retirados, **nuevo** diagrama de actividades de cancelación de reserva. Parte 3: caso de uso UC45, `EstadoAlquiler.ANULADO`, **nueva** secuencia de anulación y diagrama de clases integrado actualizado. 19 → 23 diagramas, todos con su fuente `.mmd`. |
| 4 | `docs/04-base-de-datos/` | `vehicles`: estado `RETIRED` + `deactivated_at` + `chk_vehicles_retired`. `customers`: `active` + `deactivated_at` + `chk_customers_active`. `rentals`: estado `VOIDED` + `chk_rentals_voided`. `reservations` sin cambios. Script único y ER completo actualizados y probados en PostgreSQL (PGlite 16). |

Cómo se va a ver en la API de la Fase 6 (orientativo, a confirmar al programar):
- `DELETE /api/vehicles/{id}` → baja lógica (pasa a `RETIRED`), nunca un `DELETE` SQL.
- `DELETE /api/customers/{id}` → desactiva el cliente.
- Reactivar, cancelar y anular son cambios de estado. Para respetar la convención de endpoints sin
  verbos (`CLAUDE.md` sección 6), se resuelven actualizando el recurso con `PUT` e indicando el
  nuevo estado (por ejemplo `PUT /api/rentals/{id}` con estado `VOIDED`). La forma exacta se decide
  en la Fase 6.
- Los listados ocultan por defecto los registros dados de baja y aceptan un filtro para verlos.

## 5. Fuera de alcance (a propósito)

- **Eliminación definitiva o anonimización de datos personales** a pedido del titular (derecho de
  supresión de la Ley 25.326 de Protección de Datos Personales). El borrado lógico conserva los
  datos del cliente. Si la empresa lo necesita, sería una historia nueva (anonimizar nombre,
  documento y contacto conservando los alquileres). No se agrega ahora para no sumar complejidad que
  nadie pidió.
- **Motivo de la baja** (vendido, siniestrado, etc.) como dato estructurado: alcanza con la fecha
  de baja para el MVP.
- **Login del cliente**: sigue sin existir (RE03). "Dar de baja la cuenta" de un cliente equivale a
  desactivar su registro de Cliente, y "volver a usarla" es reactivarlo.

## 6. Observación aparte (no incluida en este cambio)

En `docs/03-uml/03-alquileres-mariocardona970546.md`, sección 1, la relación `UC41 → UC35`
("Iniciar alquiler" → "Confirmar reserva") está dibujada como `include` con la condición "si viene
de reserva". Un `<<include>>` es obligatorio (se ejecuta siempre); uno condicional debería ser
`<<extend>>`. Es la misma corrección que el instructor le marcó al Grupo 1. **No se tocó**: se
deja anotada para que la corrija el dueño de la Parte 3.

## 7. Qué falta validar

- [ ] ¿El equipo está de acuerdo con el borrado lógico como regla general (RN15)?
- [ ] ¿Las 3 historias nuevas (US1.7, US2.5, US4.5) y sus puntos son correctos?
- [x] ¿La reactivación automática del cliente desde el formulario público (RF58) es lo que se
      quiere, o debería reactivarlo solo un empleado? → **Confirmado: se reactiva
      automáticamente** (chaarlyez, 2026-10-08).
- [x] ¿Anular un alquiler debe cancelar también su reserva de origen (RF56)? → **Sí, confirmado**
      (chaarlyez, 2026-10-08).
- [ ] Johann-Tafur y mariocardona970546 revisan los cambios hechos en sus partes de las Fases 3 y 4.
