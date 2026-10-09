# Fase 3 — Fuentes editables de los diagramas UML

Esta carpeta contiene el **archivo fuente editable** de cada uno de los 23 diagramas UML de la
Fase 3, versionado en el repositorio (19 originales + 4 agregados por el cambio de borrado lógico,
[`../../cambios/01-borrado-logico.md`](../../cambios/01-borrado-logico.md)). Cada archivo `.mmd` es texto plano en sintaxis
[Mermaid](https://mermaid.js.org/): se puede abrir, modificar y volver a generar el diagrama sin
depender de una imagen exportada ni de una herramienta paga.

Los documentos de cada parte (`../01-...md`, `../02-...md`, `../03-...md`) muestran el mismo
diagrama embebido para poder leerlo directamente en GitHub. Las tablas de abajo indican qué fuente
corresponde a cada diagrama y en qué sección del documento está.

## Cómo editar un diagrama

1. Abrir el `.mmd` correspondiente con cualquiera de estas opciones:
   - [Mermaid Live Editor](https://mermaid.live) (en el navegador, sin instalar nada): pegar el
     contenido del archivo, editar y ver el resultado al instante.
   - VS Code con una extensión de vista previa de Mermaid (por ejemplo *Mermaid Preview*).
2. Guardar el cambio en el `.mmd`.
3. Copiar el mismo contenido al bloque ` ```mermaid ` del documento de la parte correspondiente
   (columna "Documento" de las tablas de abajo), para que el `.md` y la fuente queden iguales.
4. Hacer commit de los dos archivos juntos.

> **Regla**: la fuente (`.mmd`) y el bloque embebido en el `.md` deben tener siempre el mismo
> contenido. Si se cambia uno, se cambia el otro en el mismo commit.

Si hace falta una imagen (para una presentación o un PDF), se exporta desde Mermaid Live Editor
(botones PNG / SVG). Las imágenes exportadas no se versionan: se regeneran desde la fuente.

## Parte 1 — Johann-Tafur (E1 Vehículos + E2 Clientes)

Documento: [`../01-johann-tafur-vehiculos-clientes.md`](../01-johann-tafur-vehiculos-clientes.md)

| Fuente | Tipo de diagrama | Sección del documento |
|---|---|---|
| [`parte1-casos-de-uso-vehiculos-clientes.mmd`](parte1-casos-de-uso-vehiculos-clientes.mmd) | Casos de uso | 1 |
| [`parte1-clases-vehiculo-cliente.mmd`](parte1-clases-vehiculo-cliente.mmd) | Clases (`Vehiculo`, `Cliente`) | 2 |
| [`parte1-secuencia-registrar-vehiculo.mmd`](parte1-secuencia-registrar-vehiculo.mmd) | Secuencia | 3.1 |
| [`parte1-secuencia-registrar-cliente.mmd`](parte1-secuencia-registrar-cliente.mmd) | Secuencia | 3.2 |
| [`parte1-estados-vehiculo.mmd`](parte1-estados-vehiculo.mmd) | Estados (`Vehiculo`) | 4.1 |
| [`parte1-actividades-mantenimiento-vehiculo.mmd`](parte1-actividades-mantenimiento-vehiculo.mmd) | Actividades | 4.2 |
| [`parte1-estados-cliente.mmd`](parte1-estados-cliente.mmd) | Estados (`Cliente`, borrado lógico) | 4.3 |
| [`parte1-actividades-baja-vehiculo.mmd`](parte1-actividades-baja-vehiculo.mmd) | Actividades (baja lógica de vehículo) | 4.4 |

## Parte 2 — chaarlyez (E3 Reservas + E5 Autogestión de Reservas del Cliente)

Documento: [`../02-reservas-chaarlyez.md`](../02-reservas-chaarlyez.md)

| Fuente | Tipo de diagrama | Sección del documento |
|---|---|---|
| [`parte2-casos-de-uso-reservas.mmd`](parte2-casos-de-uso-reservas.mmd) | Casos de uso | 1 |
| [`parte2-clases-reserva.mmd`](parte2-clases-reserva.mmd) | Clases (`Reserva`) | 2 |
| [`parte2-secuencia-reserva-empleado.mmd`](parte2-secuencia-reserva-empleado.mmd) | Secuencia | 3.1 |
| [`parte2-secuencia-reserva-publica.mmd`](parte2-secuencia-reserva-publica.mmd) | Secuencia | 3.2 |
| [`parte2-actividades-validacion-solapamiento.mmd`](parte2-actividades-validacion-solapamiento.mmd) | Actividades | 4.1 |
| [`parte2-actividades-reutilizacion-cliente.mmd`](parte2-actividades-reutilizacion-cliente.mmd) | Actividades | 4.2 |
| [`parte2-actividades-cancelar-reserva.mmd`](parte2-actividades-cancelar-reserva.mmd) | Actividades (cancelación de reserva) | 4.3 |

## Parte 3 — mariocardona970546 (E4 Alquileres + integración final)

Documento: [`../03-alquileres-mariocardona970546.md`](../03-alquileres-mariocardona970546.md)

| Fuente | Tipo de diagrama | Sección del documento |
|---|---|---|
| [`parte3-casos-de-uso-alquileres.mmd`](parte3-casos-de-uso-alquileres.mmd) | Casos de uso | 1 |
| [`parte3-clases-alquiler.mmd`](parte3-clases-alquiler.mmd) | Clases (`Alquiler`) | 2 |
| [`parte3-clases-integracion-final.mmd`](parte3-clases-integracion-final.mmd) | Clases (sistema completo, las 3 partes unificadas) | 3 |
| [`parte3-secuencia-iniciar-alquiler.mmd`](parte3-secuencia-iniciar-alquiler.mmd) | Secuencia | 4.1 |
| [`parte3-secuencia-finalizar-alquiler.mmd`](parte3-secuencia-finalizar-alquiler.mmd) | Secuencia | 4.2 |
| [`parte3-secuencia-anular-alquiler.mmd`](parte3-secuencia-anular-alquiler.mmd) | Secuencia (anulación de alquiler) | 4.3 |
| [`parte3-actividades-flujo-alquiler.mmd`](parte3-actividades-flujo-alquiler.mmd) | Actividades | 5.1 |
| [`parte3-estados-alquiler.mmd`](parte3-estados-alquiler.mmd) | Estados (`Alquiler`) | 5.2 |
