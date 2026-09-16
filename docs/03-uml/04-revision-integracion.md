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

## Observación menor (no bloqueante)

La Parte 1 dibuja las relaciones con línea no dirigida (`--`), mientras que la Parte 2 y la Parte 3
usan flecha dirigida (`-->`). Es una diferencia cosmética de notación entre archivos individuales,
sin impacto porque el diagrama de clases integrado (Parte 3, sección 3, que es el que cuenta como
entregable único del sistema) usa flechas dirigidas de forma consistente en las 4 clases. No
amerita pedir un cambio.

## Conclusión

Las 3 partes son coherentes entre sí y con `docs/01-epicas-historias-usuario.md` y
`docs/02-requerimientos.md`. No se encontraron contradicciones que bloqueen el cierre de la Fase 3.
