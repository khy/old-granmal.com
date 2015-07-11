define ['jquery', 'underscore'], ($) ->

  setMainMinHeight = ->
    minHeight = $(window).height() - $('header').height()
    newStyle = $("<style class='main-min-height'>main { min-height: #{minHeight}px; }</style>")
    existingStyle = $('style.main-min-height')

    if (existingStyle.length > 0)
      existingStyle.replaceWith newStyle
    else
      newStyle.appendTo('head')

  ensureFullPage: (el) ->
    setMainMinHeight()
    $("footer").removeClass("hidden")
    $(window).resize _.debounce setMainMinHeight, 100
