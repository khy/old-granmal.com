require.config
  paths:
    jquery: '../vendor/jquery-2.1.0'

define ['jquery'], ($) ->

  resizeMasthead = ->
    windowHeight = $(window).height()
    $('.masthead .poster').height windowHeight - 40

    listMinHeight = windowHeight - $('.nav').height()
    $('.apps').css('min-height', listMinHeight)

  conditionallyAffixHeader = (threshold) ->
    if ($(window).scrollTop() >= threshold)
      $('.container').addClass('affix-header')
    else
      $('.container').removeClass('affix-header')

  navTop = 0

  $ ->
    resizeMasthead()
    navTop = $('.nav').offset().top
    conditionallyAffixHeader(navTop)

  $(window).resize ->
    resizeMasthead()
    navTop = $('.nav').offset().top

  $(window).scroll ->
    conditionallyAffixHeader(navTop)
