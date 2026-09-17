# Fase 3 — Parte 3 (mariocardona970546): Alquileres + integración final del diagrama de clases

**Alcance**: E4 — Gestión de Alquileres (`docs/01-epicas-historias-usuario.md`, historias
US4.1-US4.4), según `docs/03-uml/00-asignacion.md`. Basado en `docs/02-requerimientos.md`
(RF34-RF41, RN04, RN05, RN11, RN13, RN14).

Las clases `Vehiculo` y `Cliente` son responsabilidad de la Parte 1 (Johann-Tafur,
`01-johann-tafur-vehiculos-clientes.md`) y `Reserva` de la Parte 2 (chaarlyez,
`02-reservas-chaarlyez.md`) — acá se referencian como colaboradoras de `Alquiler`, sin redefinir
sus atributos, salvo en la sección 3 donde se integra el diagrama de clases completo (tarea que
esta parte tiene asignada además de `Alquiler`).

---

## 1. Diagrama de casos de uso

Actor **Empleado** únicamente — E4 no tiene interacción del actor Cliente (eso es E5, Parte 2).

```mermaid
flowchart LR
    Empleado(["👤 Empleado"])

    UC41(["Iniciar alquiler (retiro)<br/>US4.1"])
    UC42(["Finalizar alquiler (devolución)<br/>US4.2"])
    UC43(["Listar alquileres<br/>US4.3"])
    UC44(["Consultar historial de alquileres de un cliente<br/>US4.4"])

    Empleado --> UC41
    Empleado --> UC42
    Empleado --> UC43
    Empleado --> UC44

    UC41 -.->|"include (si viene de reserva)"| UC35
    UC44 -.->|include| UC8

    UC35(["Confirmar reserva<br/>Parte 2 - chaarlyez"])
    UC8(["Buscar cliente<br/>Parte 1 - Johann-Tafur"])
```

**Relaciones `include` con otras partes**:

| Caso de uso | Incluye | Condición / regla |
|---|---|---|
| UC41 — Iniciar alquiler | UC35 (Confirmar reserva, Parte 2) | Solo si el alquiler se origina en una reserva; también puede ser directo, sin reserva previa (RN04) |
| UC44 — Consultar historial de un cliente | UC8 (Buscar cliente, Parte 1) | El historial se busca por documento del cliente, igual que UC8 (US4.4) |

---

## 2. Aporte al diagrama de clases: `Alquiler`

```mermaid
classDiagram
    class Alquiler {
        -Long id
        -LocalDateTime fechaInicioReal
        -LocalDateTime fechaFinReal
        -EstadoAlquiler estado
        -BigDecimal montoTotal
    }

    class EstadoAlquiler {
        <<enumeration>>
        ACTIVO
        FINALIZADO
    }

    class Cliente {
        <<Parte 1 - Johann-Tafur>>
    }

    class Vehiculo {
        <<Parte 1 - Johann-Tafur>>
    }

    class Reserva {
        <<Parte 2 - chaarlyez>>
    }

    Alquiler "0..*" --> "1" Cliente : retira
    Alquiler "0..*" --> "1" Vehiculo : es alquilado en
    Alquiler "0..1" --> "0..1" Reserva : se origina de
    Alquiler --> EstadoAlquiler : estado
```

Notas:
- `fechaInicioReal` / `fechaFinReal` son `LocalDateTime` (con hora), no `LocalDate` — a diferencia
  de `Reserva.fechaInicio`/`fechaFin`. Es necesario para aplicar RN13 (períodos de 24h desde el
  retiro, con 1 hora de tolerancia), que exige conocer el momento exacto, no solo el día.
- La relación con `Reserva` es `0..1` de ambos lados: un Alquiler puede no tener reserva de origen
  (alquiler directo, RN04) y una Reserva puede no derivar nunca en un Alquiler (si se cancela).
- `montoTotal` es `BigDecimal` (no `double`), igual criterio que `Vehiculo.precioPorDia` (Parte 1)
  para evitar errores de redondeo en montos de dinero.

---

## 3. Integración final del diagrama de clases (las 3 partes unificadas)

Tarea propia de esta parte (ver `docs/03-uml/00-asignacion.md`): juntar los aportes de Johann-Tafur
(`Vehiculo`, `Cliente`), chaarlyez (`Reserva`) y esta parte (`Alquiler`) en un solo diagrama, sin
contradecir ninguno de los tres.

```mermaid
classDiagram
    class Vehiculo {
        -Long id
        -String patente
        -String marca
        -String modelo
        -int anio
        -String tipo
        -EstadoVehiculo estado
        -BigDecimal precioPorDia
    }

    class Cliente {
        -Long id
        -String nombre
        -String apellido
        -String documento
        -String email
        -String telefono
    }

    class Reserva {
        -Long id
        -LocalDate fechaInicio
        -LocalDate fechaFin
        -EstadoReserva estado
    }

    class Alquiler {
        -Long id
        -LocalDateTime fechaInicioReal
        -LocalDateTime fechaFinReal
        -EstadoAlquiler estado
        -BigDecimal montoTotal
    }

    class EstadoVehiculo {
        <<enumeration>>
        DISPONIBLE
        ALQUILADO
        MANTENIMIENTO
    }

    class EstadoReserva {
        <<enumeration>>
        PENDIENTE
        CONFIRMADA
        CANCELADA
    }

    class EstadoAlquiler {
        <<enumeration>>
        ACTIVO
        FINALIZADO
    }

    Cliente "1" --> "0..*" Reserva : realiza
    Vehiculo "1" --> "0..*" Reserva : es reservado en
    Cliente "1" --> "0..*" Alquiler : retira
    Vehiculo "1" --> "0..*" Alquiler : es alquilado en
    Reserva "0..1" --> "0..1" Alquiler : origina
    Vehiculo ..> EstadoVehiculo : usa
    Reserva ..> EstadoReserva : usa
    Alquiler ..> EstadoAlquiler : usa
```

**Decisiones tomadas al integrar** (para que Johann-Tafur y chaarlyez puedan revisarlas):

| Decisión | Por qué |
|---|---|
| Se mantienen los 4 atributos de `Vehiculo` y `Cliente` exactamente como los definió la Parte 1 | No había ningún conflicto con `Alquiler` — `Vehiculo`/`Cliente` no necesitan ningún atributo nuevo por el lado de Alquileres. |
| Se mantiene `Reserva` exactamente como la definió la Parte 2 | Mismo criterio — sin conflictos. |
| `Reserva` y `Alquiler` quedan `0..1`–`0..1` (no `1`–`1`) | RF34/RN04: un alquiler puede ser directo, sin reserva; y una reserva puede cancelarse sin llegar a ser alquiler nunca. |
| Se reemplazan los placeholders `<<Parte 2 - chaarlyez>>` / `<<Parte 3 - mariocardona970546>>` de los diagramas parciales por las clases completas | Esos placeholders eran intencionales en los archivos `01-...` y `02-...` — ahí se aclara que la integración final la hace esta parte, así que no se tocan esos archivos, se integra acá. |

---

## 4. Diagramas de secuencia

### 4.1 Iniciar alquiler / retiro de vehículo (US4.1 — RF34, RF35, RF36, RN04)

```mermaid
sequenceDiagram
    actor Empleado
    participant Controlador
    participant Servicio
    participant Repositorio
    participant BaseDeDatos as Base de Datos

    Empleado->>Controlador: iniciar alquiler (cliente, vehiculo, reserva opcional)
    Controlador->>Servicio: iniciarAlquiler(datos)
    Servicio->>Repositorio: buscarVehiculo(vehiculoId)
    Repositorio->>BaseDeDatos: SELECT vehiculo
    BaseDeDatos-->>Repositorio: vehiculo
    Repositorio-->>Servicio: vehiculo

    alt vehículo ya está ALQUILADO (RF36)
        Servicio-->>Controlador: error: vehículo no disponible
        Controlador-->>Empleado: 409 Conflict
    else vehículo disponible
        opt viene de una reserva
            Servicio->>Repositorio: buscarReserva(reservaId)
            Repositorio->>BaseDeDatos: SELECT reserva
            BaseDeDatos-->>Repositorio: reserva
            Repositorio-->>Servicio: reserva (debe estar CONFIRMADA, RN04)
        end
        Servicio->>Repositorio: guardar(alquiler, estado = ACTIVO, fechaInicioReal = ahora)
        Repositorio->>BaseDeDatos: INSERT alquiler
        BaseDeDatos-->>Repositorio: alquiler creado
        Repositorio-->>Servicio: alquiler
        Servicio->>Repositorio: actualizarEstadoVehiculo(vehiculoId, ALQUILADO) (RF35, RN11)
        Repositorio->>BaseDeDatos: UPDATE vehiculo SET estado = ALQUILADO
        BaseDeDatos-->>Repositorio: ok
        Servicio-->>Controlador: alquiler creado
        Controlador-->>Empleado: 201 Created
    end
```

### 4.2 Finalizar alquiler / devolución (US4.2 — RF37, RF38, RF39, RN05, RN13)

```mermaid
sequenceDiagram
    actor Empleado
    participant Controlador
    participant Servicio
    participant Repositorio
    participant BaseDeDatos as Base de Datos

    Empleado->>Controlador: finalizar alquiler (fechaFinReal, estadoVehiculoFinal)
    Controlador->>Servicio: finalizarAlquiler(id, datos)
    Servicio->>Repositorio: buscarAlquiler(id)
    Repositorio->>BaseDeDatos: SELECT alquiler
    BaseDeDatos-->>Repositorio: alquiler (ACTIVO)
    Repositorio-->>Servicio: alquiler

    Servicio->>Servicio: calcular días efectivos (RN13)<br/>períodos de 24h desde fechaInicioReal,<br/>1h de tolerancia antes de sumar un día más
    Servicio->>Servicio: montoTotal = díasEfectivos × vehiculo.precioPorDia (RN05)

    Servicio->>Repositorio: guardar(alquiler, estado = FINALIZADO, montoTotal)
    Repositorio->>BaseDeDatos: UPDATE alquiler
    BaseDeDatos-->>Repositorio: ok
    Servicio->>Repositorio: actualizarEstadoVehiculo(vehiculoId, estadoVehiculoFinal) (RF39)
    Repositorio->>BaseDeDatos: UPDATE vehiculo SET estado = DISPONIBLE|MANTENIMIENTO
    BaseDeDatos-->>Repositorio: ok
    Servicio-->>Controlador: alquiler finalizado (montoTotal, díasEfectivos)
    Controlador-->>Empleado: 200 OK
```

---

## 5. Diagramas de actividades

### 5.1 Flujo completo de un alquiler: bloqueo por alquiler activo + cálculo de días efectivos

Cubre RF34-RF39, RN04, RN05, RN11, RN13.

```mermaid
flowchart TD
    Start(["Inicio: Empleado quiere iniciar un alquiler"]) --> Origen{"¿Viene de una reserva o es directo?"}
    Origen -- "Desde reserva (RN04)" --> ValReserva{"¿La reserva está CONFIRMADA?"}
    ValReserva -- No --> R1["Rechazar: la reserva debe estar confirmada"]
    R1 --> Fin1(["Fin"])
    ValReserva -- Sí --> ValVehiculo
    Origen -- "Directo, sin reserva (RN04)" --> ValVehiculo

    ValVehiculo{"¿El vehículo ya está ALQUILADO? (RF36)"}
    ValVehiculo -- Sí --> R2["Rechazar: vehículo ya alquilado"]
    R2 --> Fin1

    ValVehiculo -- No --> Crear["Crear Alquiler ACTIVO<br/>fechaInicioReal = ahora"]
    Crear --> Ocupar["Vehículo pasa a ALQUILADO (RF35, RN11)"]
    Ocupar --> Uso["... el cliente usa el vehículo ..."]
    Uso --> Devolucion["Empleado registra la devolución (fechaFinReal)"]
    Devolucion --> Calcular["Calcular días efectivos:<br/>períodos de 24h desde fechaInicioReal,<br/>+1 día si se supera 1h de tolerancia (RN13)"]
    Calcular --> Monto["montoTotal = díasEfectivos × precioPorDia (RN05)"]
    Monto --> Finalizar["Alquiler pasa a FINALIZADO"]
    Finalizar --> EstadoFinal["Vehículo pasa a DISPONIBLE o MANTENIMIENTO,<br/>según indique el Empleado (RF39)"]
    EstadoFinal --> Fin2(["Fin: alquiler finalizado y facturado"])
```

### 5.2 Estados de `Alquiler` (complementa el diagrama de estados de `Vehiculo` de la Parte 1)

La Parte 1 (`01-johann-tafur-vehiculos-clientes.md`, sección 4.1) dejó marcadas como
"Parte 3 - Alquileres" las transiciones de `Vehiculo` hacia/desde `ALQUILADO` — este diagrama
muestra el lado del `Alquiler` que las dispara.

```mermaid
stateDiagram-v2
    [*] --> ACTIVO : iniciar alquiler (RF34) — dispara Vehiculo: DISPONIBLE/CONFIRMADA -> ALQUILADO
    ACTIVO --> FINALIZADO : finalizar alquiler (RF37) — dispara Vehiculo: ALQUILADO -> DISPONIBLE/MANTENIMIENTO
    FINALIZADO --> [*]
```

---

## 6. Trazabilidad

| Diagrama | Historias | Requerimientos / Reglas |
|---|---|---|
| Casos de uso | US4.1–US4.4 | RF34–RF41 |
| Clases (`Alquiler`) | US4.1, US4.2 | RN04, RN05, RN13 |
| Integración final del diagrama de clases | — | RN04 (relación Reserva–Alquiler) |
| Secuencia — iniciar alquiler | US4.1 | RF34, RF35, RF36, RN04, RN11 |
| Secuencia — finalizar alquiler | US4.2 | RF37, RF38, RF39, RN05, RN13 |
| Actividades — flujo completo de alquiler | US4.1, US4.2 | RF34–RF39, RN04, RN05, RN11, RN13 |
| Estados de `Alquiler` | US4.1, US4.2 | RN04 |

---

## 7. Qué falta validar

- [x] ¿El diagrama de casos de uso (sección 1) cubre completo US4.1-US4.4, y las relaciones
      `include` con las Partes 1 y 2 son correctas? → **Sí.**
- [x] ¿La clase `Alquiler` (sección 2) tiene los atributos y relaciones correctos? → **Sí.**
- [x] ¿El diagrama de clases integrado (sección 3) es consistente con lo que definieron
      Johann-Tafur y chaarlyez, sin contradecir ninguna de sus dos partes? → **Sí, confirmado**
      también en `docs/03-uml/04-revision-integracion.md`.
- [x] ¿Los diagramas de secuencia (sección 4) reflejan bien RF34-RF39 y el cálculo de RN13? →
      **Sí.**
- [x] ¿El diagrama de actividades (sección 5) cubre correctamente el bloqueo por alquiler activo
      (RF36) y el cálculo de días efectivos (RN13)? → **Sí.**

**Parte 3 validada.** Con esto se cierra formalmente la **Fase 3** completa en
`docs/00-roadmap.md` y `CLAUDE.md`.
