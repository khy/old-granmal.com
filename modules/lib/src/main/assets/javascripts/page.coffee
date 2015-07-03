define ['jquery'], ($) ->

  resizeContent = (el) ->
    minHeight = $(window).height() - $('header, .header').height()
    $(el).css('min-height', minHeight)

  ensureFullPage = (el) ->
    unless el
      # The first child of .container that is neither the header nor the footer
      el = $(".container > [class!=header]:not(header)[class!=footer]:first")

    if $(el).length > 0
      resizeContent(el)
      $(window).resize -> resizeContent(el)

  ensureFullPage: ensureFullPage
