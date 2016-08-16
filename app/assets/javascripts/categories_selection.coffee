$(document).on 'turbolinks:load', ->
  $('.categories-selection').find('select').on 'change', ->
    this.form.submit()
