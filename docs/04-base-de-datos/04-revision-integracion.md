# Fase 4 — Revisión de coherencia entre las 3 partes

Revisión final antes de cerrar la Fase 4, hecha por mariocardona970546 sobre los 3 documentos
entregados: `01-johann-tafur-vehiculos-clientes.md` (Parte 1), `02-reservas-chaarlyez.md`
(Parte 2) y `03-alquileres-mariocardona970546.md` (Parte 3, que incluye la integración final del
script SQL y del diagrama ER).

## Qué se verificó

1. **Nombres y tipos de las columnas `id`/FK, consistentes entre las 4 tablas**: `id` es
   `BIGSERIAL` en las 4 tablas y toda FK que apunta a un `id` está tipada como `BIGINT` (no hay
   mezcla de tipos numéricos entre PK y FK): `reservations.vehicle_id`/`customer_id` y
   `rentals.vehicle_id`/`customer_id`/`reservation_id`.

2. **Convención de `status`, igual en las 3 tablas que lo usan**: `vehicles.status`,
   `reservations.status` y `rentals.status` usan el mismo patrón `VARCHAR(20) NOT NULL DEFAULT
   '<estado inicial>' CHECK (status IN (...))`, en vez de `ENUM` nativo — decisión explícita de la
   Parte 1 y replicada sin discutirla de nuevo por las Partes 2 y 3. Los valores por defecto
   (`AVAILABLE`, `PENDING`, `ACTIVE`) coinciden con RF04, RN09 y RF34 respectivamente.

3. **Relaciones y multiplicidades, sin contradicciones entre partes**:
   - `Vehiculo 1 — 0..* Reserva` y `Cliente 1 — 0..* Reserva`: la Parte 1 (sección 3, ER) y la
     Parte 2 (sección 3) dibujan la misma relación desde lados opuestos, sin contradecirse.
   - `Vehiculo 1 — 0..* Alquiler` y `Cliente 1 — 0..* Alquiler`: igual, entre la Parte 1 y la
     Parte 3.
   - `Reserva 0..1 — 0..1 Alquiler` (RN04): implementada como `rentals.reservation_id` opcional
     (`NULL` permitido) **y** `UNIQUE` — el `UNIQUE` fue un ajuste posterior sobre la entrega
     inicial de la Parte 3 (commit `ba21319`, "agregar UNIQUE a reservation_id en rentals") para
     que la multiplicidad `0..1` del lado de `Alquiler` en el diagrama de clases integrado
     (Fase 3, `03-alquileres-mariocardona970546.md` sección 3) quede reflejada también a nivel de
     esquema — sin el `UNIQUE`, nada impedía que dos alquileres distintos apuntaran a la misma
     reserva. Corregido y coherente ahora.

4. **`price_per_day` (`vehicles`) y `total_amount` (`rentals`)**: ambos `NUMERIC(10,2)`, mismo
   criterio anti-redondeo aplicado consistentemente por las Partes 1 y 3, tal como quedó anotado
   en ambos documentos.

5. **Granularidad de fechas, intencionalmente distinta y documentada por qué**:
   `reservations.start_date`/`end_date` son `DATE` (RN12, solapamiento por día) mientras que
   `rentals.actual_start_date`/`actual_end_date` son `TIMESTAMP` (RN13, tolerancia de 1 hora). No
   es una inconsistencia: cada tabla usa la granularidad que su propia regla de negocio exige, y
   ambas partes lo dejaron explícito en sus notas de diseño.

6. **Ningún placeholder quedó sin reemplazar**: la Parte 3 (sección 3, versión final) referencia
   `vehicles`, `customers` y `reservations` solo con su PK como placeholder — correcto, porque
   redefinir sus columnas ahí hubiera duplicado (y arriesgado desalinear) lo que ya definieron las
   Partes 1 y 2 en sus propios archivos. El script SQL único (sección 5 de la Parte 3) sí usa las
   columnas reales de las 4 tablas.

## Observación menor (no bloqueante)

`vehicles.type` queda como texto libre (`VARCHAR(30)` sin `CHECK`) mientras que `vehicles.status`,
`reservations.status` y `rentals.status` sí llevan `CHECK` cerrado. No es una inconsistencia: la
Parte 1 lo documentó a propósito (ningún requerimiento define un dominio fijo de tipos de
vehículo, a diferencia de los estados que sí están enumerados en RN01). No amerita cambio.

## Conclusión

Las 3 partes son coherentes entre sí y con `docs/02-requerimientos.md` y el diagrama de clases
integrado de la Fase 3. No se encontraron contradicciones que bloqueen el cierre de la Fase 4.
