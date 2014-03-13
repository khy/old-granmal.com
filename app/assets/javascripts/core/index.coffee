define ['jquery', 'core/layout'], ($, layout) ->

  resizeMasthead = ->
    windowHeight = $(window).height()
    $('.masthead .poster').height windowHeight - 40

    listMinHeight = windowHeight - $('.nav').height()
    $('.list').css('min-height', listMinHeight)

  init: ->
    navTop = $('.nav').offset().top

    resizeMasthead()
    $(window).resize ->
      resizeMasthead()
      navTop = $('.nav').offset().top

    layout.conditionallyAffixHeader(navTop)
    $(window).scroll ->
      layout.conditionallyAffixHeader(navTop)
