# Guía de estilo visual — Tema "VeloRent" (Fase 5)

> Referencia de estilo para **todo el equipo**. Se definió a partir de la imagen
> `Ideas/VeloRent_ lujo sobre ruedas.png`. Todas las pantallas del prototipo (de cualquier
> integrante) deben seguir este estilo para que el prototipo se vea como un solo producto.

## 1. La idea en una línea

Tema **oscuro de lujo**: fondo casi negro, acentos **dorados**, texto claro y **títulos con
tipografía serif** (Playfair Display). Botón principal dorado relleno; botón secundario
"fantasma" (transparente con borde dorado).

## 2. Dónde vive el estilo

Todo el estilo está en **`prototipo/estilos.css`**, que **comparten todas las pantallas**. Por eso,
si cambia el tema, cambian todas las pantallas a la vez; nadie tiene que tocar su HTML.

- **Guía navegable (abrir en el navegador):** `prototipo/guia-estilo.html` — muestra en vivo los
  colores, la tipografía, los botones, los campos, los estados y los avisos. Es la referencia
  principal porque siempre está sincronizada con el CSS.
- Este `.md` es el resumen escrito; ante cualquier duda, vale lo que se ve en `guia-estilo.html`.

## 3. Regla de equipo (importante)

1. Las pantallas usan **solo las clases y los tokens** (variables) de `estilos.css`.
2. **No se escriben colores a mano** en el HTML (nada de `style="color:#..."` ni colores sueltos).
3. Si una pantalla necesita un estilo que no existe, **se agrega al CSS** (no al HTML) y **se avisa
   en el PR**, para que todos lo tengan.
4. Para una pantalla nueva, partir de `plantilla.html` (back-office) o `plantilla-publica.html`
   (formulario público). Enlazar siempre `estilos.css`, y `validacion.js` si tiene formulario.

## 4. Tokens de color (variables CSS)

Se usan como `var(--nombre)`:

| Token | Valor | Uso |
|---|---|---|
| `--color-fondo` | `#0f0f12` | Fondo de la página (casi negro) |
| `--color-superficie` | `#1a1a1f` | Tarjetas, menú, encabezado |
| `--color-superficie-2` | `#141418` | Campos de formulario |
| `--color-primario` | `#c9a24e` | Dorado de marca (acento, botón principal, activo) |
| `--color-primario-oscuro` | `#b1883a` | Dorado al pasar el mouse (hover) |
| `--color-primario-texto` | `#1a1206` | Texto oscuro sobre el botón dorado |
| `--color-texto` | `#f3f1ec` | Texto principal (blanco cálido) |
| `--color-texto-suave` | `#a5a39c` | Texto secundario, ayudas |
| `--color-borde` | `#2b2b31` | Bordes de tarjetas, campos, tablas |
| `--color-peligro` | `#e5736a` | Errores, acción destructiva |
| `--color-exito` | `#5fb97e` | Confirmaciones, estados "ok" |
| `--color-aviso` | `#d9a441` | Advertencias, estados "en espera" |

## 5. Tipografía

- **Títulos (`h1`, `h2`, encabezado):** `--fuente-titulo` → `"Playfair Display", Georgia, serif`.
  Playfair se carga por `@import` de Google Fonts; **si no hay internet, cae a Georgia** y se sigue
  viendo serif.
- **Texto, formularios, tablas:** `--fuente-texto` → sans-serif del sistema.

## 6. Componentes y sus clases

| Componente | Clases |
|---|---|
| Botón principal (dorado) | `.boton` |
| Botón secundario (fantasma) | `.boton.secundario` |
| Botón peligro (rojo) | `.boton.peligro` |
| Tarjeta (caja de contenido) | `.tarjeta` |
| Campo de formulario | `.campo` + `<label>` + `<input>`/`<select>` |
| Campo con error | `.campo.error` + `.mensaje-error` (lo pone `validacion.js`) |
| Marca de obligatorio | `<span class="obligatorio">*</span>` (se ve dorado) |
| Estado verde (Disponible, Confirmada, Activo) | `.estado.ok` |
| Estado ámbar (Pendiente, Mantenimiento, Alquilado) | `.estado.espera` |
| Estado gris (Retirado, Cancelada, Anulado, Finalizado) | `.estado.baja` |
| Aviso informativo / éxito / advertencia / error | `.aviso` / `.aviso.exito` / `.aviso.advertencia` / `.aviso.error` |
| Tabla de listado (responsive) | `.tabla` (cada `<td>` lleva `data-label="Columna"`) |
| Pasos del formulario público | `.pasos` + `.pasos li` (el actual: `.actual`) |

## 7. Responsive

Todo es **mobile-first**: los estilos por defecto son para celular y el bloque
`@media (min-width: 768px)` ajusta a escritorio. Revisar cada pantalla en **375 px** (móvil) y
**1280 px** (escritorio), como ya veníamos haciendo.

## 8. Nota sobre la marca

La imagen de referencia usa el nombre **"VeloRent"**. Por ahora las pantallas conservan el texto
genérico "Alquiler de Vehículos"; si el grupo decide adoptar "VeloRent" como nombre, se cambia el
texto del encabezado en cada pantalla (el estilo ya está preparado para ese nombre).
