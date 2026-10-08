# Fase 3 — Parte 1 (Johann-Tafur): Vehículos y Clientes

Alcance: **E1 — Gestión de Vehículos** y **E2 — Gestión de Clientes**
(`docs/01-epicas-historias-usuario.md`), 25 puntos de historia. Trazabilidad completa a los
requerimientos funcionales y reglas de negocio de `docs/02-requerimientos.md`.

Ver la división completa de la Fase 3 en `docs/03-uml/00-asignacion.md`.

## 1. Diagrama de casos de uso

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'primaryColor': '#ffffff',
  'primaryBorderColor': '#4a4a4a',
  'primaryTextColor': '#1a1a1a',
  'lineColor': '#4a4a4a',
  'textColor': '#1a1a1a',
  'clusterBkg': '#eef6ff',
  'clusterBorder': '#2a6fb0'
}}}%%
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

    style E1 fill:#eef6ff,stroke:#2a6fb0,color:#1a1a1a
    style E2 fill:#f3eaff,stroke:#7e3ff2,color:#1a1a1a

    classDef actor fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    classDef usecase fill:#ffffff,stroke:#4a4a4a,color:#1a1a1a
    class Empleado actor
    class UC1,UC2,UC3,UC4,UC5,UC6,UC7,UC8,UC9,UC10 usecase
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
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'primaryColor': '#eef6ff',
  'primaryBorderColor': '#2a6fb0',
  'primaryTextColor': '#1a1a1a',
  'lineColor': '#4a4a4a',
  'textColor': '#1a1a1a'
}}}%%
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

    Vehiculo "1" --> "0..*" Reserva : tiene
    Vehiculo "1" --> "0..*" Alquiler : tiene
    Cliente "1" --> "0..*" Reserva : realiza
    Cliente "1" --> "0..*" Alquiler : realiza
    Vehiculo --> EstadoVehiculo : estado

    classDef own fill:#eef6ff,stroke:#2a6fb0,color:#1a1a1a
    classDef enum fill:#f3eaff,stroke:#7e3ff2,color:#1a1a1a
    classDef other fill:#f0f0f0,stroke:#9aa5b1,color:#5a5a5a
    class Vehiculo:::own
    class Cliente:::own
    class EstadoVehiculo:::enum
    class Reserva:::other
    class Alquiler:::other
```

Notas:
- `documento` (Cliente) y `patente` (Vehiculo) son identificadores de negocio únicos — RN06, RN07.
- Al crearse un `Vehiculo`, `estado` queda en `DISPONIBLE` automáticamente (RF04).

## 3. Diagramas de secuencia

### 3.1 Registrar vehículo nuevo (US1.1 — RF01, RF02, RF03, RF04)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'actorBkg': '#eef6ff',
  'actorBorder': '#2a6fb0',
  'actorTextColor': '#1a1a1a',
  'actorLineColor': '#4a4a4a',
  'signalColor': '#1a1a1a',
  'signalTextColor': '#1a1a1a',
  'labelBoxBkgColor': '#fff4e0',
  'labelBoxBorderColor': '#c97a1e',
  'labelTextColor': '#1a1a1a',
  'loopTextColor': '#1a1a1a',
  'noteBkgColor': '#fff9c4',
  'noteBorderColor': '#c9a400',
  'noteTextColor': '#1a1a1a',
  'activationBorderColor': '#2a6fb0',
  'activationBkgColor': '#eafaf0',
  'sequenceNumberColor': '#1a1a1a'
}}}%%
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
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'actorBkg': '#eef6ff',
  'actorBorder': '#2a6fb0',
  'actorTextColor': '#1a1a1a',
  'actorLineColor': '#4a4a4a',
  'signalColor': '#1a1a1a',
  'signalTextColor': '#1a1a1a',
  'labelBoxBkgColor': '#fff4e0',
  'labelBoxBorderColor': '#c97a1e',
  'labelTextColor': '#1a1a1a',
  'loopTextColor': '#1a1a1a',
  'noteBkgColor': '#fff9c4',
  'noteBorderColor': '#c9a400',
  'noteTextColor': '#1a1a1a',
  'activationBorderColor': '#2a6fb0',
  'activationBkgColor': '#eafaf0',
  'sequenceNumberColor': '#1a1a1a'
}}}%%
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
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'primaryColor': '#eafaf0',
  'primaryBorderColor': '#2f9e5c',
  'primaryTextColor': '#1a1a1a',
  'lineColor': '#4a4a4a',
  'textColor': '#1a1a1a'
}}}%%
stateDiagram-v2
    [*] --> DISPONIBLE : alta de vehículo (RF04)
    DISPONIBLE --> MANTENIMIENTO : marcar mantenimiento (RF14, US1.6)
    MANTENIMIENTO --> DISPONIBLE : finalizar mantenimiento (RF14, US1.6)
    DISPONIBLE --> ALQUILADO : retiro de vehículo (Parte 3 - Alquileres)
    ALQUILADO --> DISPONIBLE : devolución de vehículo (Parte 3 - Alquileres)

    classDef own fill:#eafaf0,stroke:#2f9e5c,color:#1a1a1a
    classDef other fill:#f0f0f0,stroke:#9aa5b1,color:#5a5a5a
    class DISPONIBLE:::own
    class MANTENIMIENTO:::own
    class ALQUILADO:::other
```

### 4.2 Diagrama de actividades: marcar/desmarcar mantenimiento (US1.6 — RF14, RF15)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'primaryColor': '#eef6ff',
  'primaryBorderColor': '#2a6fb0',
  'primaryTextColor': '#1a1a1a',
  'lineColor': '#4a4a4a',
  'textColor': '#1a1a1a'
}}}%%
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

    classDef startEnd fill:#eafaf0,stroke:#2f9e5c,color:#1a1a1a
    classDef decision fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    classDef action fill:#ffffff,stroke:#4a4a4a,color:#1a1a1a
    classDef reject fill:#fdeaea,stroke:#c0392b,color:#1a1a1a
    class Start,Fin1,Fin2 startEnd
    class B,D decision
    class A,E,F action
    class C reject
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
