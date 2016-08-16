$(document).on 'turbolinks:load', ->
  header = $('body>h1.head').first().text()

  if header.length
    top.document.title = "#{header} / Pupesoft"
