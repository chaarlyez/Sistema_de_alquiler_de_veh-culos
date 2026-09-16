# Fase 3 — Diagramas UML: división del trabajo

La Fase 3 se divide en 3 partes, una por integrante, agrupando las épicas de la Fase 1
(`docs/01-epicas-historias-usuario.md`) para que cada parte sea un bloque coherente del dominio.
Cada parte entrega, para sus épicas: diagrama de casos de uso, aporte al diagrama de clases,
diagramas de secuencia y diagramas de actividades de sus flujos más representativos.

El **diagrama de clases** es uno solo para todo el sistema (las entidades se relacionan entre sí),
así que cada parte aporta sus clases y quien integra arma la versión final unificada.

## Parte 1 — Johann-Tafur

**Alcance**: E1 Gestión de Vehículos + E2 Gestión de Clientes (25 puntos de historia).

- Diagrama de casos de uso: actor Empleado gestionando vehículos y clientes.
- Aporte al diagrama de clases: `Vehiculo` y `Cliente` (atributos, estados, relaciones).
- Diagramas de secuencia: alta de vehículo, alta/edición de cliente.
- Diagramas de actividades: cambio de estado de un vehículo (Disponible / Alquilado /
  Mantenimiento).

## Parte 2 — chaarlyez

**Alcance**: E3 Gestión de Reservas + E5 Autogestión de Reservas del Cliente (21 puntos de
historia).

- Diagrama de casos de uso: actor Empleado (reserva manual) y actor Cliente (formulario público de
  autogestión).
- Aporte al diagrama de clases: `Reserva`.
- Diagramas de secuencia: creación de reserva por un empleado; creación de reserva pública por un
  cliente (incluye reutilización de `Cliente` existente por documento vs. alta de uno nuevo).
- Diagramas de actividades: flujo de reserva con validación de solapamiento de fechas (regla de
  negocio de `docs/02-requerimientos.md`).

## Parte 3 — mariocardona970546

**Alcance**: E4 Gestión de Alquileres (13 puntos de historia) + integración final del diagrama de
clases general.

- Diagrama de casos de uso: actor Empleado gestionando el retiro y la devolución de un vehículo.
- Diagrama de clases: `Alquiler`, y unificación del diagrama completo con los aportes de las otras
  dos partes (`Vehiculo`, `Cliente`, `Reserva`, `Alquiler` y sus relaciones).
- Diagramas de secuencia: retiro de vehículo (Reserva → Alquiler), devolución/finalización de
  alquiler con cálculo del monto total.
- Diagramas de actividades: flujo de alquiler con bloqueo por alquiler activo y cálculo de días
  efectivos (reglas de negocio de `docs/02-requerimientos.md`).

## Notas

- Los tres diagramas de casos de uso individuales se pueden mantener separados por claridad, o
  combinarse en uno solo del sistema completo al cerrar la fase — a decidir al integrar.
- Nivel junior: diagramas simples y legibles, sin notación UML avanzada innecesaria (ver
  `CLAUDE.md`, sección 1).
