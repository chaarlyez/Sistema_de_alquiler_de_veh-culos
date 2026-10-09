# Fase 3 — Revisión de coherencia entre las 3 partes

Revisión final antes de cerrar la Fase 3, hecha por chaarlyez sobre los 3 documentos entregados:
`01-johann-tafur-vehiculos-clientes.md` (Parte 1), `02-reservas-chaarlyez.md` (Parte 2) y
`03-alquileres-mariocardona970546.md` (Parte 3, que incluye la integración final del diagrama de
clases).

## Qué se verificó

1. **Atributos de cada clase, consistentes entre el archivo que la define y el diagrama de clases
   integrado (Parte 3, sección 3)**:
   - `Vehiculo` (Parte 1): id, patente, marca, modelo, anio, tipo, estado, precioPorDia — igual en
     ambos lugares.
   - `Cliente` (Parte 1): id, nombre, apellido, documento, email, telefono — igual en ambos
     lugares.
   - `Reserva` (Parte 2): id, fechaInicio, fechaFin, estado — igual en ambos lugares.
   - `Alquiler` (Parte 3): id, fechaInicioReal, fechaFinReal, estado, montoTotal — igual en ambos
     lugares.
   - Ninguna parte redefinió atributos de una clase ajena; los placeholders `<<Parte N - nombre>>`
     se respetaron en los 3 archivos individuales, tal como estaba acordado en
     `00-asignacion.md`.

2. **Relaciones y multiplicidades, sin contradicciones entre partes**:
   - `Cliente 1 — 0..* Reserva` y `Vehiculo 1 — 0..* Reserva`: coinciden entre lo que dibuja la
     Parte 1 (desde el lado de `Vehiculo`/`Cliente`) y lo que dibuja la Parte 2 (desde el lado de
     `Reserva`).
   - `Cliente 1 — 0..* Alquiler` y `Vehiculo 1 — 0..* Alquiler`: coinciden entre la Parte 1 y la
     Parte 3.
   - `Reserva 0..1 — 0..1 Alquiler` (RN04): la Parte 2 dejó explícitamente esta relación para que
     la integrara la Parte 3, sin dibujarla dos veces — la Parte 3 la agregó con la multiplicidad
     `0..1`–`0..1` correcta (un alquiler puede ser directo sin reserva; una reserva puede
     cancelarse sin derivar en alquiler nunca). Coherente con RF34 y RN04 de
     `docs/02-requerimientos.md`.

3. **Referencias cruzadas entre casos de uso de distintas partes**: la Parte 3 referencia
   `UC35` ("Confirmar reserva") y `UC8` ("Buscar cliente") usando los mismos IDs que usaron la
   Parte 2 y la Parte 1 respectivamente para esos mismos casos de uso — sin duplicar ni
   renombrar. Correcto.

4. **Estados de `Vehiculo` vs. `Alquiler`**: la Parte 1 dejó marcadas las transiciones
   `DISPONIBLE → ALQUILADO` y `ALQUILADO → DISPONIBLE` como disparadas por la Parte 3; la Parte 3
   las completa con su propio diagrama de estados de `Alquiler`, sin contradecir el de la Parte 1.

## Observación menor (corregida)

La Parte 1 dibujaba las relaciones con línea no dirigida (`--`), mientras que la Parte 2 y la
Parte 3 usan flecha dirigida (`-->`). En su momento se consideró una diferencia cosmética sin
impacto, porque el diagrama de clases integrado (Parte 3, sección 3, que es el entregable único
del sistema) ya usaba flechas dirigidas de forma consistente en las 4 clases. Una revisión
posterior del instructor pidió homogeneizar también los diagramas individuales, así que se
corrigió: las 4 relaciones de `01-johann-tafur-vehiculos-clientes.md` (sección 2) ahora usan
`-->`, igual que el resto. Con esto, los 3 archivos individuales y el diagrama integrado usan la
misma notación de extremo a extremo.

## Revisión del cambio de borrado lógico

Cambio agregado después del cierre (`docs/cambios/01-borrado-logico.md`). Se revisó que las 3
partes lo reflejen igual:

- `EstadoVehiculo.RETIRADO`, `Vehiculo.fechaBaja`, `Cliente.activo` y `Cliente.fechaBaja` están
  igual en la Parte 1 (sección 2) y en la integración final de la Parte 3 (sección 3).
- `EstadoAlquiler.ANULADO` está igual en la clase `Alquiler` (Parte 3, sección 2) y en la
  integración final.
- Las transiciones cruzadas coinciden: la anulación de un alquiler (Parte 3, 4.3 y 5.2) devuelve
  el vehículo a `DISPONIBLE` (Parte 1, 4.1) y pasa la reserva de origen a `CANCELADA` (Parte 2,
  nota de la sección 2). La reactivación automática del cliente en el formulario público (Parte 2,
  3.2 y 4.2) es la misma transición `INACTIVO → ACTIVO` del diagrama de estados de `Cliente`
  (Parte 1, 4.3).
- Los 23 diagramas siguen siendo iguales a su fuente `.mmd`, y se verificó que todos renderizan
  sin errores con `mermaid-cli`.

Queda una observación de notación **que no se corrigió** en este cambio, para que la revise el
dueño de la parte: en la Parte 3 (sección 1), `UC41 → UC35` está dibujado como `include` con la
condición "si viene de reserva". Un `<<include>>` significa que el caso incluido se ejecuta
**siempre**; si es condicional, corresponde `<<extend>>` (la misma corrección que el instructor le
marcó al Grupo 1).

## Conclusión

Las 3 partes son coherentes entre sí y con `docs/01-epicas-historias-usuario.md` y
`docs/02-requerimientos.md`. No se encontraron contradicciones que bloqueen el cierre de la Fase 3.
