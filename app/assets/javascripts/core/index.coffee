define ['jquery', 'core/layout'], ($, layout) ->

  resizeMasthead = ->
    windowHeight = $(window).height()
    $('.masthead .poster').height windowHeight - 40

    listMinHeight = windowHeight - $('.nav').height()
    $('.apps').css('min-height', listMinHeight)

  init: ->
    resizeMasthead()
    navTop = $('.nav').offset().top
    layout.conditionallyAffixHeader(navTop)

    $(window).resize ->
      resizeMasthead()
      navTop = $('.nav').offset().top

    $(window).scroll ->
      layout.conditionallyAffixHeader(navTop)
