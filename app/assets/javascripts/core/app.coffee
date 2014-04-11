define ['jquery', 'lib'], ($, lib) ->

  conditionallyAffixHeader = (threshold) ->
    if ($(window).scrollTop() >= threshold)
      $('.container').addClass('affix-header')
    else
      $('.container').removeClass('affix-header')

  resizeMasthead = ->
    $('.masthead .poster').height $(window).height() - 40

  initIndex = ->
    navTop = 0

    $(document).ready ->
      resizeMasthead()
      navTop = $('.nav').offset().top
      conditionallyAffixHeader(navTop)

    $(window).resize ->
      resizeMasthead()
      navTop = $('.nav').offset().top

    $(window).scroll ->
      conditionallyAffixHeader(navTop)

  init: ->
    console.debug 'Initializing Core...'

    if $('.masthead').length > 0
      lib.ensureFullPage('.apps')
      initIndex()
