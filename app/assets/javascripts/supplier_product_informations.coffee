$(document).on 'page:change', ->
  $('#supplier').on 'change', ->
    this.form.submit()
