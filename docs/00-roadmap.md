# Roadmap del trabajo integrador — Sistema de Alquiler de Vehículos

Este documento trackea el avance de las 6 fases definidas para el trabajo integrador. Se actualiza
al cerrar cada fase.

| # | Fase | Actividades principales | Entregable | Estado |
|---|---|---|---|---|
| 1 | Épica y Stories | Definir problema, objetivo, usuarios y funcionalidades principales. Crear épicas y dividirlas en historias de usuario. | Épicas + Historias de usuario | ✅ Cerrada |
| 2 | Requerimientos | Identificar y documentar requerimientos funcionales y no funcionales. Definir reglas de negocio y criterios de aceptación. | Documento de requerimientos | ✅ Cerrada |
| 3 | Diagramas UML | Modelar el sistema a partir de los requerimientos. Casos de uso, clases, secuencia, actividades. | Diagramas UML | ✅ Cerrada |
| 4 | Base de datos | Identificar entidades, atributos y relaciones. Modelo conceptual, lógico y físico. Script SQL. | Modelo ER/UML + Script de BD | 🔶 En curso |
| 5 | Mockup / Prototipo | Diseñar interfaces principales y flujo de navegación. Validar experiencia antes de programar. | Mockup/prototipo navegable | ⬜ Pendiente |
| 6 | Programa funcional | Seleccionar tecnologías, desarrollar funcionalidades prioritarias, integrar frontend, backend y BD, pruebas. | MVP funcional | ⬜ Pendiente |

## Decisiones que aplican a todas las fases

- **Idioma de la documentación**: español (fases 1 a 5).
- **Idioma del código**: inglés — nombres de clases/variables/métodos y comentarios (fase 6). El
  scaffolding creado en la sesión de setup técnico (paquete `com.alquilervehiculos`) usa nombres en
  español y se va a renombrar a inglés recién al llegar a la Fase 6, para no duplicar trabajo.
- **Nivel**: junior — documentos y modelos simples, sin sobre-ingeniería. Ver `CLAUDE.md` para las
  convenciones generales del proyecto.

## Ubicación de entregables

```
docs/
├── 00-roadmap.md                      (este archivo)
├── 01-epicas-historias-usuario.md     (Fase 1)
├── 02-requerimientos.md               (Fase 2)
├── 03-uml/                            (Fase 3 - cerrada)
│   ├── 00-asignacion.md               (división del trabajo en 3 partes)
│   ├── 01-johann-tafur-vehiculos-clientes.md
│   ├── 02-reservas-chaarlyez.md
│   ├── 03-alquileres-mariocardona970546.md
│   └── 04-revision-integracion.md     (revisión de coherencia entre las 3 partes)
├── 04-base-de-datos/                  (Fase 4 - en curso)
│   ├── 00-asignacion.md               (división del trabajo en 3 partes)
│   └── 02-reservas-chaarlyez.md
└── 05-mockups/                        (Fase 5 - pendiente)
```

## Fase 3 — división del trabajo

La Fase 3 se dividió en 3 partes, una por integrante del equipo, agrupando las épicas de la Fase 1.
Ver el detalle de alcance y entregables de cada parte en `docs/03-uml/00-asignacion.md`.

| Parte | Integrante | Épicas | Estado |
|---|---|---|---|
| 1 | Johann-Tafur | E1 Vehículos + E2 Clientes | ✅ Validada |
| 2 | chaarlyez | E3 Reservas + E5 Autogestión de Reservas del Cliente | ✅ Validada |
| 3 | mariocardona970546 | E4 Alquileres + integración final del diagrama de clases | ✅ Validada |

Las 3 partes fueron revisadas en conjunto por coherencia (atributos, relaciones, multiplicidades y
referencias cruzadas entre casos de uso) — ver `docs/03-uml/04-revision-integracion.md`. Sin
contradicciones encontradas. Las 3 partes tienen además su propio checklist de validación de
contenido marcado y confirmado (ver sección 7 de `03-alquileres-mariocardona970546.md` para la
última en cerrarse). **Fase 3 cerrada.** Se pasa a la Fase 4 (Base de datos) en
`docs/04-base-de-datos/`.

## Fase 4 — división del trabajo

Misma mecánica que la Fase 3: se divide en 3 partes, una por integrante, conservando la misma
agrupación de entidades (quien modeló una clase en UML pasa esa clase a tabla acá). Ver el detalle
de alcance y entregables de cada parte en `docs/04-base-de-datos/00-asignacion.md`.

| Parte | Integrante | Tablas | Estado |
|---|---|---|---|
| 1 | Johann-Tafur | `vehicles` + `customers` | ⬜ Pendiente |
| 2 | chaarlyez | `reservations` | 🔶 Entregada, falta validar |
| 3 | mariocardona970546 | `rentals` + integración final del script SQL y diagrama ER | ⬜ Pendiente |
