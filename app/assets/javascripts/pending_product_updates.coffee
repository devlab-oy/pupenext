console.log('kala')
$(document).on 'page:change', ->
  $('tr.rows:odd').addClass('tumma')
