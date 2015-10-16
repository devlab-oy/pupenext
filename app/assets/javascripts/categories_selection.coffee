$(document).on 'page:change', ->
  $('.categories-selection').find('select').on 'change', ->
    this.form.submit()
