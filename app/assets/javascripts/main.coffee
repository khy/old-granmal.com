require.config
  paths:
    'jquery':     'vendor/jquery-2.1.0'
    'underscore': 'vendor/underscore-1.6.0'

require [
  'jquery'
  'underscore'
], ($, _) ->

  resizeMasthead = ->
    navHeight = $('.nav').outerHeight()
    windowHeight = $(window).height()
    $('.masthead').height(windowHeight - (navHeight + 20))

  resizeMasthead()

  $(window).resize _.throttle resizeMasthead, 100

  originalNavTop = $('.nav').offset().top

  conditionallyAffixHeader = ->
    if ($(window).scrollTop() >= originalNavTop)
      $('.container').addClass('affix-header')
    else
      $('.container').removeClass('affix-header')

  conditionallyAffixHeader()

  $(window).scroll conditionallyAffixHeader
