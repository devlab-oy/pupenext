$(document).on 'page:change', ->
  header = $('body>h1.head').first().text()

  if header.length
    top.document.title = "#{header} / Pupesoft"
