define ['jquery'], ($) ->

  resizeContent = (el) ->
    listMinHeight = $(window).height() - $('.nav').height()
    $(el).css('min-height', listMinHeight)

  ensureFullPage = (el) ->
    $(document).ready ->
      if $(el).length > 0
        resizeContent(el)
        $(window).resize -> resizeContent(el)

  ensureFullPage: ensureFullPage
