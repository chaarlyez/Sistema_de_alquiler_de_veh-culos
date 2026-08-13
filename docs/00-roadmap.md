# Roadmap del trabajo integrador — Sistema de Alquiler de Vehículos

Este documento trackea el avance de las 6 fases definidas para el trabajo integrador. Se actualiza
al cerrar cada fase.

| # | Fase | Actividades principales | Entregable | Estado |
|---|---|---|---|---|
| 1 | Épica y Stories | Definir problema, objetivo, usuarios y funcionalidades principales. Crear épicas y dividirlas en historias de usuario. | Épicas + Historias de usuario | 🟡 En curso |
| 2 | Requerimientos | Identificar y documentar requerimientos funcionales y no funcionales. Definir reglas de negocio y criterios de aceptación. | Documento de requerimientos | ⬜ Pendiente |
| 3 | Diagramas UML | Modelar el sistema a partir de los requerimientos. Casos de uso, clases, secuencia, actividades. | Diagramas UML | ⬜ Pendiente |
| 4 | Base de datos | Identificar entidades, atributos y relaciones. Modelo conceptual, lógico y físico. Script SQL. | Modelo ER/UML + Script de BD | ⬜ Pendiente |
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
├── 02-requerimientos.md               (Fase 2 - pendiente)
├── 03-uml/                            (Fase 3 - pendiente)
├── 04-base-de-datos/                  (Fase 4 - pendiente)
└── 05-mockups/                        (Fase 5 - pendiente)
```
