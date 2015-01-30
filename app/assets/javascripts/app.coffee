define ['jquery', 'lib/page'], ($, page) ->

  resizeMasthead = ->
    $('.masthead .poster').height $(window).height() - 40

  initMasthead: ->
    document.ontouchmove = (e) -> e.preventDefault()
    $(document).ready -> resizeMasthead()
    $(window).resize -> resizeMasthead()

  init: ->
    page.ensureFullPage()
    $(document).ready -> $('.container').addClass('affix-header')
