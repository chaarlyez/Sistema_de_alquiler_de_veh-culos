# Fase 3 — Parte 1 (Johann-Tafur): Vehículos y Clientes

Alcance: **E1 — Gestión de Vehículos** y **E2 — Gestión de Clientes**
(`docs/01-epicas-historias-usuario.md`), 25 puntos de historia. Trazabilidad completa a los
requerimientos funcionales y reglas de negocio de `docs/02-requerimientos.md`.

Ver la división completa de la Fase 3 en `docs/03-uml/00-asignacion.md`.

## 1. Diagrama de casos de uso

```mermaid
flowchart LR
    Empleado((Empleado))

    subgraph E1["Gestión de Vehículos (E1)"]
        UC1(["Registrar vehículo<br/>US1.1"])
        UC2(["Listar vehículos<br/>US1.2"])
        UC3(["Modificar vehículo<br/>US1.3"])
        UC4(["Dar de baja vehículo<br/>US1.4"])
        UC5(["Buscar vehículos disponibles<br/>US1.5"])
        UC6(["Marcar / desmarcar mantenimiento<br/>US1.6"])
    end

    subgraph E2["Gestión de Clientes (E2)"]
        UC7(["Registrar cliente<br/>US2.1"])
        UC8(["Buscar cliente<br/>US2.2"])
        UC9(["Modificar cliente<br/>US2.3"])
        UC10(["Eliminar cliente<br/>US2.4"])
    end

    Empleado --> UC1
    Empleado --> UC2
    Empleado --> UC3
    Empleado --> UC4
    Empleado --> UC5
    Empleado --> UC6
    Empleado --> UC7
    Empleado --> UC8
    Empleado --> UC9
    Empleado --> UC10
```

**Relaciones `<<include>>` con otras partes** (dependen de datos de Reserva/Alquiler, fuera del
alcance de esta parte, ver `docs/03-uml/00-asignacion.md`):

| Caso de uso | Incluye | Regla |
|---|---|---|
| UC4 — Dar de baja vehículo | Verificar que el vehículo no tenga un alquiler ACTIVO | RF11 |
| UC5 — Buscar vehículos disponibles | Excluir vehículos con reserva solapada o alquiler ACTIVO | RF13, RN12, RN14 |
| UC6 — Marcar/desmarcar mantenimiento | Verificar que el vehículo no tenga un alquiler ACTIVO | RF15 |
| UC10 — Eliminar cliente | Verificar que el cliente no tenga reservas/alquileres activos | RF24, RN08 |

## 2. Diagrama de clases (aporte de esta parte)

El diagrama de clases es único para todo el sistema; esta parte aporta `Vehiculo` y `Cliente`.
`Reserva` y `Alquiler` se muestran como referencia (los completan las otras partes al integrar).

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

    class EstadoVehiculo {
        <<enumeration>>
        DISPONIBLE
        ALQUILADO
        MANTENIMIENTO
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
        <<Parte 2 - chaarlyez>>
    }

    class Alquiler {
        <<Parte 3 - mariocardona970546>>
    }

    Vehiculo "1" -- "0..*" Reserva : tiene
    Vehiculo "1" -- "0..*" Alquiler : tiene
    Cliente "1" -- "0..*" Reserva : realiza
    Cliente "1" -- "0..*" Alquiler : realiza
    Vehiculo --> EstadoVehiculo : estado
```

Notas:
- `documento` (Cliente) y `patente` (Vehiculo) son identificadores de negocio únicos — RN06, RN07.
- Al crearse un `Vehiculo`, `estado` queda en `DISPONIBLE` automáticamente (RF04).

## 3. Diagramas de secuencia

### 3.1 Registrar vehículo nuevo (US1.1 — RF01, RF02, RF03, RF04)

```mermaid
sequenceDiagram
    actor Empleado
    participant Controlador
    participant Servicio
    participant Repositorio
    participant BaseDeDatos as Base de Datos

    Empleado->>Controlador: registrar vehículo (patente, marca, modelo, anio, tipo, precioPorDia)
    Controlador->>Servicio: registrarVehiculo(datos)
    Servicio->>Servicio: validar campos obligatorios (RF02)
    alt faltan campos obligatorios
        Servicio-->>Controlador: error: datos incompletos
        Controlador-->>Empleado: 400 Bad Request
    else campos completos
        Servicio->>Repositorio: existePorPatente(patente)
        Repositorio->>BaseDeDatos: SELECT ... WHERE patente = ?
        BaseDeDatos-->>Repositorio: resultado
        Repositorio-->>Servicio: existe true/false
        alt patente ya registrada (RF03)
            Servicio-->>Controlador: error: patente duplicada
            Controlador-->>Empleado: 409 Conflict
        else patente disponible
            Servicio->>Servicio: asignar estado = DISPONIBLE (RF04)
            Servicio->>Repositorio: guardar(vehiculo)
            Repositorio->>BaseDeDatos: INSERT INTO vehiculos ...
            BaseDeDatos-->>Repositorio: vehículo guardado (id)
            Repositorio-->>Servicio: vehiculo
            Servicio-->>Controlador: vehiculo creado
            Controlador-->>Empleado: 201 Created
        end
    end
```

### 3.2 Registrar cliente nuevo (US2.1 — RF16, RF17, RF18)

```mermaid
sequenceDiagram
    actor Empleado
    participant Controlador
    participant Servicio
    participant Repositorio
    participant BaseDeDatos as Base de Datos

    Empleado->>Controlador: registrar cliente (nombre, apellido, documento, email, telefono)
    Controlador->>Servicio: registrarCliente(datos)
    Servicio->>Servicio: validar campos obligatorios (RF17)
    alt faltan campos obligatorios
        Servicio-->>Controlador: error: datos incompletos
        Controlador-->>Empleado: 400 Bad Request
    else campos completos
        Servicio->>Repositorio: existePorDocumento(documento)
        Repositorio->>BaseDeDatos: SELECT ... WHERE documento = ?
        BaseDeDatos-->>Repositorio: resultado
        Repositorio-->>Servicio: existe true/false
        alt documento ya registrado (RF18)
            Servicio-->>Controlador: error: documento duplicado
            Controlador-->>Empleado: 409 Conflict
        else documento disponible
            Servicio->>Repositorio: guardar(cliente)
            Repositorio->>BaseDeDatos: INSERT INTO clientes ...
            BaseDeDatos-->>Repositorio: cliente guardado (id)
            Repositorio-->>Servicio: cliente
            Servicio-->>Controlador: cliente creado
            Controlador-->>Empleado: 201 Created
        end
    end
```

## 4. Diagrama de estados y de actividades

### 4.1 Diagrama de estados de Vehiculo (RN01)

Las transiciones hacia/desde `ALQUILADO` las genera el flujo de Alquileres (Parte 3); se muestran
acá solo para que el diagrama de estados quede completo.

```mermaid
stateDiagram-v2
    [*] --> DISPONIBLE : alta de vehículo (RF04)
    DISPONIBLE --> MANTENIMIENTO : marcar mantenimiento (RF14, US1.6)
    MANTENIMIENTO --> DISPONIBLE : finalizar mantenimiento (RF14, US1.6)
    DISPONIBLE --> ALQUILADO : retiro de vehículo (Parte 3 - Alquileres)
    ALQUILADO --> DISPONIBLE : devolución de vehículo (Parte 3 - Alquileres)
```

### 4.2 Diagrama de actividades: marcar/desmarcar mantenimiento (US1.6 — RF14, RF15)

```mermaid
flowchart TD
    Start([Inicio]) --> A[Empleado selecciona un vehículo]
    A --> B{"¿Tiene un alquiler ACTIVO?"}
    B -- Sí --> C["Sistema rechaza la operación (RF15)"]
    C --> Fin1([Fin])
    B -- No --> D{"¿Estado actual es MANTENIMIENTO?"}
    D -- Sí --> E["Sistema marca el vehículo como DISPONIBLE"]
    D -- No --> F["Sistema marca el vehículo como MANTENIMIENTO"]
    E --> Fin2([Fin])
    F --> Fin2
```

## 5. Trazabilidad

| Diagrama | Historias | Requerimientos / Reglas |
|---|---|---|
| Casos de uso | US1.1–US1.6, US2.1–US2.4 | RF01–RF24 |
| Clases (Vehiculo, Cliente) | US1.1, US2.1 | RN01, RN06, RN07 |
| Secuencia — registrar vehículo | US1.1 | RF01, RF02, RF03, RF04 |
| Secuencia — registrar cliente | US2.1 | RF16, RF17, RF18 |
| Estados de Vehiculo | US1.1, US1.6 | RN01, RF04, RF14 |
| Actividades — mantenimiento | US1.6 | RF14, RF15 |
