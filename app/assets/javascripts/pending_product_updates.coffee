$(document).on 'turbolinks:load', ->
  $('.pending_update').on 'cocoon:after-insert', (e, added_row) ->
    added_row.parent().parent().find(".submit").show()

  $('.price-select').on 'change', ->
      this.form.submit()
