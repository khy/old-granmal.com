require.config
  paths:
    'jquery': 'vendor/jquery-2.1.0'

require ['jquery'], ($) ->

  navTop = $('.nav').offset().top

  resizePage = ->
    windowHeight = $(window).height()
    $('.masthead').height windowHeight - 40

    listMinHeight = windowHeight - $('.nav').height()
    $('.list').css("min-height", listMinHeight)

    navTop = $('.nav').offset().top

  resizePage()

  $(window).resize resizePage

  conditionallyAffixHeader = ->
    if ($(window).scrollTop() >= navTop)
      $('.container').addClass('affix-header')
    else
      $('.container').removeClass('affix-header')

  conditionallyAffixHeader()

  $(window).scroll conditionallyAffixHeader
