define ['jquery', 'lib'], ($, lib) ->

  conditionallyAffixHeader = (threshold) ->
    if ($(window).scrollTop() >= threshold)
      $('.container').addClass('affix-nav')
    else
      $('.container').removeClass('affix-nav')

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

    lib.ensureFullPage('.apps')

    if $('.masthead').length > 0
      initIndex()
    else
      $(document).ready ->
        $('.container').addClass('affix-nav')
