define ['jquery'], ($) ->

  resizeList = ->
    listMinHeight = $(window).height() - $('.nav').height()
    $('.haikus').css('min-height', listMinHeight)

  init: ->
    console.debug 'Initializing Haikunst!...'

    $(document).ready resizeList

    $(window).resize resizeList
