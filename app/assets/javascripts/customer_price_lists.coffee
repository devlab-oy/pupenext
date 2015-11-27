$(document).on 'page:change', ->
  $('#target_type').on 'change', (e) ->
    e.target.form.submit()
