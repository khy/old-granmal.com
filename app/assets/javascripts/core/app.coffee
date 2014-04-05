define ['jquery'], ($) ->

  conditionallyAffixHeader = (threshold) ->
    if ($(window).scrollTop() >= threshold)
      $('.container').addClass('affix-header')
    else
      $('.container').removeClass('affix-header')

  resizeIndex = ->
    windowHeight = $(window).height()
    $('.masthead .poster').height windowHeight - 40

    listMinHeight = windowHeight - $('.nav').height()
    $('.apps').css('min-height', listMinHeight)

  initIndex = ->
    navTop = 0

    $(document).ready ->
      resizeIndex()
      navTop = $('.nav').offset().top
      conditionallyAffixHeader(navTop)

    $(window).resize ->
      resizeIndex()
      navTop = $('.nav').offset().top

    $(window).scroll ->
      conditionallyAffixHeader(navTop)

  init: ->
    console.debug 'Initializing Core...'

    if $('.masthead').length > 0
      initIndex()
