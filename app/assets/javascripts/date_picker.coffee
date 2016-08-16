$(document).on 'turbolinks:load', ->
  if $('.pickadate').length
    $('.pickadate').pickadate({
      firstDay: true,
      selectYears: true,
      selectMonths: true,
      format: 'yyyy-mm-dd',
      formatSubmit: 'yyyy-mm-dd',
      monthsFull: $('#pickadate_data').data('months'),
      weekdaysShort: $('#pickadate_data').data('weekdays'),
      today: '',
      close: '',
      clear: ''
    })
