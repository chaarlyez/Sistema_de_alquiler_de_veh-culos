# Fase 3 — Parte 2 (chaarlyez): Reservas y Autogestión del Cliente

**Alcance**: E3 — Gestión de Reservas + E5 — Autogestión de Reservas del Cliente (según
`docs/03-uml/00-asignacion.md`). Basado en `docs/01-epicas-historias-usuario.md` (historias
US3.1-US3.5, US5.1-US5.2) y `docs/02-requerimientos.md` (RF25-RF45, RN02-RN04, RN09-RN14; más
RF53, RF58 y RN15-RN17 del cambio de borrado lógico, `docs/cambios/01-borrado-logico.md`).

Las clases `Cliente` y `Vehiculo` son responsabilidad de la Parte 1 (Johann-Tafur, E1+E2) — acá se
referencian como colaboradoras de `Reserva`, sin redefinir sus atributos. La integración final del
diagrama de clases completo la arma la Parte 3 (mariocardona970546).

---

## 1. Diagrama de casos de uso

Actor **Empleado**: crea, lista, cancela y confirma reservas (E3). Actor **Cliente**: usa el
formulario público, sin login, para buscar disponibilidad y reservar (E5). `Validar
disponibilidad` es un caso de uso compartido: lo incluyen tanto la reserva manual del empleado
como la reserva pública del cliente (misma lógica, reutilizada — ver Fase 1, sección 7).

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'background': '#ffffff',
  'primaryColor': '#ffffff',
  'primaryBorderColor': '#4a4a4a',
  'primaryTextColor': '#1a1a1a',
  'lineColor': '#4a4a4a',
  'textColor': '#1a1a1a'
}}}%%
flowchart LR
    Empleado(["👤 Empleado"])
    Cliente(["👤 Cliente"])

    UC31(["Crear reserva<br/>US3.1"])
    UC33(["Listar reservas<br/>US3.3"])
    UC34(["Cancelar reserva (queda en el historial)<br/>US3.4"])
    UC35(["Confirmar reserva<br/>US3.5"])
    UC32(["Validar disponibilidad<br/>US3.2 / RN12 / RN14"])

    UC51(["Buscar vehículos disponibles<br/>US5.1 (público)"])
    UC52(["Reservar vehículo<br/>US5.2 (público)"])
    UC_CLI(["Reutilizar, reactivar o crear cliente<br/>RF44 / RF58 / RN10"])

    Empleado --> UC31
    Empleado --> UC33
    Empleado --> UC34
    Empleado --> UC35

    Cliente --> UC51
    Cliente --> UC52

    UC31 -.->|include| UC32
    UC52 -.->|include| UC32
    UC52 -.->|include| UC51
    UC52 -.->|include| UC_CLI

    classDef actor fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    classDef usecase fill:#eef6ff,stroke:#2a6fb0,color:#1a1a1a
    classDef shared fill:#f3eaff,stroke:#7e3ff2,color:#1a1a1a
    class Empleado,Cliente actor
    class UC31,UC33,UC34,UC35,UC51,UC52,UC_CLI usecase
    class UC32 shared
```

---

## 2. Aporte al diagrama de clases: `Reserva`

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
    class Reserva {
        -Long id
        -LocalDate fechaInicio
        -LocalDate fechaFin
        -EstadoReserva estado
        +crear(cliente, vehiculo, fechaInicio, fechaFin)
        +confirmar()
        +cancelar()
    }

    class EstadoReserva {
        <<enumeration>>
        PENDIENTE
        CONFIRMADA
        CANCELADA
    }

    class Cliente {
        <<Parte 1 - Johann-Tafur>>
    }

    class Vehiculo {
        <<Parte 1 - Johann-Tafur>>
    }

    Reserva "0..*" --> "1" Cliente : pertenece a
    Reserva "0..*" --> "1" Vehiculo : reserva
    Reserva --> EstadoReserva : estado

    classDef own fill:#eef6ff,stroke:#2a6fb0,color:#1a1a1a
    classDef enum fill:#f3eaff,stroke:#7e3ff2,color:#1a1a1a
    classDef other fill:#f0f0f0,stroke:#9aa5b1,color:#5a5a5a
    class Reserva:::own
    class EstadoReserva:::enum
    class Cliente:::other
    class Vehiculo:::other
```

**Notas para la integración (Parte 3)**:
- `Reserva` nace siempre en `PENDIENTE` (RN09); solo pasa a `CONFIRMADA` vía US3.5.
- `cancelar()` es el "borrado" de una reserva: la pasa a `CANCELADA` y la conserva en el historial
  (RN15). Una reserva también pasa a `CANCELADA` si se anula el alquiler que generó (RF56, Parte 3).
  No hace falta un atributo extra: el estado ya cumple la función de borrado lógico.
- La relación con `Alquiler` (Parte 3) es: una `Reserva` `CONFIRMADA` puede derivar en **como
  máximo un** `Alquiler` (RN04) — esa asociación la dibuja la Parte 3 al integrar, no se duplica
  acá para no generar inconsistencias entre las tres partes.

---

## 3. Diagramas de secuencia

### 3.1 Crear reserva (Empleado) — US3.1, RF25-RF28

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
    participant API as Sistema (API Reservas)
    participant SR as Servicio de Reservas
    participant BD as Base de Datos

    Empleado->>API: crear reserva (cliente, vehiculo, fechaInicio, fechaFin)
    API->>SR: crearReserva(datos)
    SR->>BD: buscar Cliente y Vehiculo por id
    BD-->>SR: existen, Vehiculo no RETIRADO y Cliente activo (RF27, RN17)
    SR->>SR: validar fechaFin > fechaInicio (RF26)

    alt fechas inválidas
        SR-->>API: rechazar (rango de fechas inválido)
        API-->>Empleado: 400 Bad Request
    else fechas válidas
        SR->>BD: ¿Vehiculo con alquiler ACTIVO? (RN14)
        BD-->>SR: sin alquiler activo
        SR->>BD: ¿solapa con reserva PENDIENTE/CONFIRMADA del vehículo? (RN12)
        BD-->>SR: sin solapamiento
        SR->>BD: guardar Reserva (estado = PENDIENTE, RN09)
        BD-->>SR: Reserva guardada
        SR-->>API: Reserva creada
        API-->>Empleado: 201 Created (Reserva)
    end
```

### 3.2 Crear reserva pública (Cliente, sin login) — US5.1, US5.2, RF42-RF45

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
    actor Cliente
    participant Form as Formulario público
    participant API as Sistema (API pública)
    participant SC as Servicio de Clientes
    participant SR as Servicio de Reservas
    participant BD as Base de Datos

    Cliente->>Form: buscar vehículos disponibles (fechaInicio, fechaFin)
    Form->>API: consultar disponibilidad (RF42)
    API->>SR: buscarDisponibles(rango)
    SR->>BD: vehículos no RETIRADOS ni en MANTENIMIENTO, sin solapamiento (RN12) ni alquiler activo (RN14)
    BD-->>SR: lista de vehículos disponibles
    SR-->>API: lista
    API-->>Form: lista de vehículos
    Form-->>Cliente: muestra vehículos disponibles

    Cliente->>Form: elige vehículo + completa datos (nombre, apellido, documento, email/teléfono)
    Form->>API: crear reserva pública (RF43)
    API->>SC: buscarClientePorDocumento(documento)

    alt Cliente ya existe y está activo (RF44 / RN10)
        SC-->>API: reutilizar Cliente existente
    else Cliente existe pero está inactivo (RF58)
        SC->>BD: reactivar Cliente (activo = true, fechaBaja = vacía)
        BD-->>SC: Cliente reactivado
        SC-->>API: reutilizar Cliente reactivado
    else Cliente no existe
        SC->>BD: crear Cliente nuevo
        BD-->>SC: Cliente creado
        SC-->>API: Cliente nuevo
    end

    API->>SR: crearReserva(cliente, vehiculo, fechas) — mismas validaciones que 3.1 (RF45)
    SR->>BD: validar disponibilidad (RN12, RN14)
    BD-->>SR: sin conflictos
    SR->>BD: guardar Reserva (PENDIENTE)
    BD-->>SR: Reserva guardada
    SR-->>API: Reserva creada
    API-->>Form: confirmación
    Form-->>Cliente: reserva confirmada
```

---

## 4. Diagramas de actividades

### 4.1 Flujo de creación de reserva con validación de solapamiento

Común a US3.1 (empleado) y US5.2 (cliente, vía formulario público) — es la misma lógica de negocio
reutilizada, según lo documentado en `docs/01-epicas-historias-usuario.md` sección 7.

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
    Start(["Inicio: solicitar reserva"]) --> Datos["Ingresar cliente, vehículo, fechaInicio, fechaFin"]
    Datos --> ValFechas{"fechaFin > fechaInicio? (RF26)"}
    ValFechas -- No --> R1["Rechazar: rango de fechas inválido"]
    R1 --> Fin(["Fin"])
    ValFechas -- Sí --> ExisteCV{"Cliente y Vehículo existen,<br/>Vehículo no RETIRADO y Cliente activo? (RF27, RN17)"}
    ExisteCV -- No --> R2["Rechazar: cliente o vehículo inexistente o dado de baja"]
    R2 --> Fin
    ExisteCV -- Sí --> Activo{"¿Vehículo con alquiler ACTIVO? (RN14)"}
    Activo -- Sí --> R3["Rechazar: vehículo con alquiler activo"]
    R3 --> Fin
    Activo -- No --> Solapa{"¿Solapa con otra reserva<br/>PENDIENTE/CONFIRMADA del vehículo? (RN12)"}
    Solapa -- Sí --> R4["Rechazar: conflicto de fechas"]
    R4 --> Fin
    Solapa -- No --> Crear["Crear Reserva en estado PENDIENTE (RN09)"]
    Crear --> Fin

    classDef startEnd fill:#eafaf0,stroke:#2f9e5c,color:#1a1a1a
    classDef decision fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    classDef action fill:#ffffff,stroke:#4a4a4a,color:#1a1a1a
    classDef reject fill:#fdeaea,stroke:#c0392b,color:#1a1a1a
    class Start,Fin startEnd
    class ValFechas,ExisteCV,Activo,Solapa decision
    class Datos,Crear action
    class R1,R2,R3,R4 reject
```

### 4.2 Flujo de reutilización/alta de cliente en el formulario público (E5)

Detalle del paso previo a la validación de disponibilidad cuando la reserva viene del formulario
público (US5.2, RF44, RF58, RN10). Si el cliente estaba dado de baja, se reactiva: es el caso del
cliente que "vuelve" y reutiliza sus datos anteriores — no aplica al flujo del empleado, que ya trabaja con un Cliente
existente (E2, Parte 1).

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
    Start(["Cliente completa formulario:<br/>nombre, apellido, documento, email/teléfono"]) --> Buscar["Buscar Cliente por documento"]
    Buscar --> Existe{"¿Existe un Cliente<br/>con ese documento? (RN10)"}
    Existe -- Sí --> Inactivo{"¿Está inactivo<br/>(dado de baja)?"}
    Inactivo -- Sí --> Reactivar["Reactivar el Cliente (RF58)"]
    Inactivo -- No --> Reusar["Reutilizar el Cliente existente"]
    Reactivar --> Reusar
    Existe -- No --> Crear["Crear Cliente nuevo con los datos ingresados"]
    Reusar --> Continuar["Continuar con validación de disponibilidad (4.1)"]
    Crear --> Continuar
    Continuar --> Fin(["Fin"])

    classDef startEnd fill:#eafaf0,stroke:#2f9e5c,color:#1a1a1a
    classDef decision fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    classDef action fill:#ffffff,stroke:#4a4a4a,color:#1a1a1a
    class Start,Fin startEnd
    class Existe,Inactivo decision
    class Buscar,Reusar,Reactivar,Crear,Continuar action
```

### 4.3 Flujo de cancelación de una reserva (US3.4 — RF30, RF31, RF53)

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
    Start(["Inicio: el cliente avisa que no va a usar la reserva"]) --> Buscar["Empleado busca la reserva (US3.3)"]
    Buscar --> Alquiler{"¿Ya derivó en un alquiler? (RF31)"}
    Alquiler -- Sí --> R1["Rechazar: la reserva ya se convirtió en alquiler<br/>(si fue un error, se anula el alquiler, US4.5)"]
    Alquiler -- No --> Estado{"¿Está PENDIENTE o CONFIRMADA?"}
    Estado -- No --> R2["Rechazar: la reserva ya está CANCELADA"]
    Estado -- Sí --> Cancelar["Pasar la reserva a CANCELADA (RF30)"]
    Cancelar --> Conservar["La reserva no se borra: queda en el historial (RF53, RN15)<br/>y deja de bloquear la disponibilidad (RN03)"]
    R1 --> Fin(["Fin"])
    R2 --> Fin
    Conservar --> Fin

    classDef startEnd fill:#eafaf0,stroke:#2f9e5c,color:#1a1a1a
    classDef decision fill:#fff4e0,stroke:#c97a1e,color:#1a1a1a
    classDef action fill:#ffffff,stroke:#4a4a4a,color:#1a1a1a
    classDef reject fill:#fdeaea,stroke:#c0392b,color:#1a1a1a
    class Start,Fin startEnd
    class Alquiler,Estado decision
    class Buscar,Cancelar,Conservar action
    class R1,R2 reject
```

---

## 5. Qué falta validar

- [x] ¿Los casos de uso de la sección 1 cubren completo US3.1-US3.5 y US5.1-US5.2? → **Sí.**
- [x] ¿La clase `Reserva` (sección 2) tiene los atributos y relaciones correctos, y es compatible
      con lo que aportaron Johann-Tafur (`Vehiculo`, `Cliente`) y mariocardona970546 (`Alquiler`,
      integración final)? → **Sí, confirmado** en `docs/03-uml/04-revision-integracion.md`.
- [x] ¿Los diagramas de secuencia (sección 3) reflejan bien RF25-RF28 y RF42-RF45? → **Sí.**
- [x] ¿El diagrama de actividades (sección 4) cubre correctamente RN09, RN12 y RN14? → **Sí.**

- [ ] ¿Los ajustes del borrado lógico (cliente inactivo que se reactiva por el formulario
      público, vehículo `RETIRADO` excluido, diagrama 4.3 de cancelación) son correctos? →
      **Pendiente de validar** (ver `docs/cambios/01-borrado-logico.md`).

**Parte 2 validada.** Ver `docs/03-uml/04-revision-integracion.md` para la revisión de coherencia
entre las 3 partes de la Fase 3.
