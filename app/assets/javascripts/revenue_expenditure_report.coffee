$(document).on 'turbolinks:load', ->
  if $('tr.custom_expenditure').length
    $('#revenue_expenditure_rows_table').on 'click', 'button.custom_expenditure_rows', ->
      id = $(this).attr 'id'
      $("tr.#{id}").toggle()
