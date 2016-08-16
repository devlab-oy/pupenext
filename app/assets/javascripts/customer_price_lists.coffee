$(document).on 'turbolinks:load', ->
  $('#target_type').on 'change', (e) ->
    e.target.form.submit()
