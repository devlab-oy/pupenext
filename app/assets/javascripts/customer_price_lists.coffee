$(document).on 'page:change', ->
  $('#target_type').on 'change', (e) ->
    e.target.form.submit()

  $('form').on 'submit', (e) ->
    button = $(this).find('input[name=commit]')

    button.val(button.data('submit-text'))
