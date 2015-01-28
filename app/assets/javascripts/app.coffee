define ['jquery', 'lib'], ($, lib) ->

  resizeMasthead = ->
    $('.masthead .poster').height $(window).height() - 40

  initMasthead: ->
    document.ontouchmove = (e) -> e.preventDefault()
    $(document).ready -> resizeMasthead()
    $(window).resize -> resizeMasthead()

  init: ->
    lib.ensureFullPage()
    $(document).ready -> $('.container').addClass('affix-header')
