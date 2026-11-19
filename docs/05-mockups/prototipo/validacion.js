/*
  Validación de campos del prototipo (Fase 5).

  OJO: esto NO es la validación real del sistema. La validación de verdad va en la
  Fase 6 (backend, con Bean Validation: @NotBlank, @Email, etc.). Acá, en el mockup,
  solo mostramos cómo responde el formulario cuando faltan datos o son inválidos,
  reusando el estilo de error que ya está en estilos.css (.campo.error y .mensaje-error).

  Cómo se usa en el HTML (todo con atributos, sin escribir JS por pantalla):
    - <form data-validar action="pantalla-siguiente.html" method="get"> ...
    - required                 -> el campo no puede quedar vacío
    - data-numerico            -> solo números (ej. documento)
    - type="email"             -> si se completa, tiene que tener formato de email
    - data-no-antes-de="idOtro"-> fecha que no puede ser anterior a la de otro campo
    - data-grupo="nombre"      -> de todos los campos con el mismo grupo, al menos uno
  Si todo está bien, el formulario navega normal a su "action". Si no, no navega.
*/

document.addEventListener('submit', function (evento) {
  var form = evento.target;
  if (!form.hasAttribute('data-validar')) return;

  var cantErrores = validarFormulario(form);
  if (cantErrores > 0) {
    evento.preventDefault(); // hay errores: no pasamos a la pantalla siguiente
    var primero = form.querySelector('.campo.error input, .campo.error select');
    if (primero) primero.focus();
  }
});

function validarFormulario(form) {
  // 1. Limpio los errores de la vez anterior.
  form.querySelectorAll('.campo').forEach(limpiarError);

  var cantErrores = 0;
  var grupos = {}; // para la regla "al menos uno" (ej. email o teléfono)

  form.querySelectorAll('input, select, textarea').forEach(function (campoInput) {
    var campo = campoInput.closest('.campo');
    if (!campo) return;
    var valor = (campoInput.value || '').trim();

    // Obligatorio y vacío.
    if (campoInput.hasAttribute('required') && valor === '') {
      marcarError(campo, 'Completá ' + etiquetaDe(campo) + '.');
      cantErrores++;
      return;
    }

    // Solo números (documento).
    if (campoInput.hasAttribute('data-numerico') && valor !== '' && !/^\d+$/.test(valor)) {
      marcarError(campo, 'El documento debe tener solo números, sin puntos ni letras.');
      cantErrores++;
      return;
    }

    // Email con formato.
    if (campoInput.type === 'email' && valor !== '' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(valor)) {
      marcarError(campo, 'Ingresá un email válido (ejemplo: nombre@correo.com).');
      cantErrores++;
      return;
    }

    // Fecha que no puede ser anterior a la de otro campo.
    var idReferencia = campoInput.getAttribute('data-no-antes-de');
    if (idReferencia && valor !== '') {
      var otro = form.querySelector('#' + idReferencia);
      if (otro && otro.value && valor < otro.value) {
        marcarError(campo, 'Esta fecha no puede ser anterior a la de ' + etiquetaDe(otro.closest('.campo')) + '.');
        cantErrores++;
        return;
      }
    }

    // Grupo "al menos uno": junto los campos para revisarlos al final.
    var grupo = campoInput.getAttribute('data-grupo');
    if (grupo) {
      if (!grupos[grupo]) grupos[grupo] = { campos: [], algunoLleno: false };
      grupos[grupo].campos.push(campo);
      if (valor !== '') grupos[grupo].algunoLleno = true;
    }
  });

  // 2. Reviso los grupos "al menos uno".
  Object.keys(grupos).forEach(function (nombre) {
    var grupo = grupos[nombre];
    if (!grupo.algunoLleno) {
      grupo.campos.forEach(function (campo, i) {
        // marco los dos en rojo, pero el mensaje va una sola vez (en el último).
        marcarError(campo, i === grupo.campos.length - 1 ? 'Completá al menos uno: email o teléfono.' : '');
      });
      cantErrores++;
    }
  });

  return cantErrores;
}

function limpiarError(campo) {
  campo.classList.remove('error');
  var mensaje = campo.querySelector('.mensaje-error');
  if (mensaje) mensaje.remove();
}

function marcarError(campo, mensaje) {
  campo.classList.add('error');
  var input = campo.querySelector('input, select, textarea');
  if (input) input.setAttribute('aria-invalid', 'true');
  if (mensaje) {
    var span = document.createElement('span');
    span.className = 'mensaje-error';
    span.textContent = mensaje;
    campo.appendChild(span);
  }
}

function etiquetaDe(campo) {
  var label = campo ? campo.querySelector('label') : null;
  if (!label) return 'este campo';
  return label.textContent.replace('*', '').trim().toLowerCase();
}
