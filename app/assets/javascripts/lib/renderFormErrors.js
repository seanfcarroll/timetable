/* global $ */

$.fn.renderFormErrors = function renderFormErrors(modelName, errors) {
  const $form = $(this);
  $form.clearFormErrors();

  $.each(errors, (field, messages) => {
    const input = $('input, select, textarea', $form).filter((i, el) => {
      const name = $(el).attr('name');
      if (!name) return false;
      return name.match(new RegExp(`${modelName}\\[${field}\\]`));
    });
    input.closest('.form-group').addClass('has-error');
    const errorsHtml = $.map(messages, m => m.charAt(0).toUpperCase() + m.slice(1)).join('<br />');
    input.parent().append(`<span class="help-block">${errorsHtml}</span>`);
  });
};
