define ['jquery'], ($) ->

  resizeContent = (el) ->
    listMinHeight = $(window).height() - $('.nav').height()
    $(el).css('min-height', listMinHeight)

  ensureFullPage = (el) ->
    unless el
      # The first child of .container that is neither the nav nor the footer
      el = $(".container > [class!=nav][class!=footer]:first")

    $(document).ready ->
      if $(el).length > 0
        resizeContent(el)
        $(window).resize -> resizeContent(el)

  ensureFullPage: ensureFullPage
