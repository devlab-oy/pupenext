$(function() {
  $('.custom_expenditure').hide();

  $('#rows_table').on('click', '.custom_expenditure_rows', function() {
    id = $(this).attr('id');
    $('.' + id).toggle();
  });
});
