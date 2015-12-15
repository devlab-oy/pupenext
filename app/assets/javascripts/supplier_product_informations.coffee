$(document).on 'page:change', ->
  $('#supplier').on 'change', ->
    this.form.submit()

  $('input[type=checkbox].transfer').on 'click', ->
    $(this).closest('tbody').find('.extra-attributes').toggle()
