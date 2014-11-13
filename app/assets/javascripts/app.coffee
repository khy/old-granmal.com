define ['jquery', 'lib'], ($, lib) ->

  resizeMasthead = ->
    $('.masthead .poster').height $(window).height() - 40

  initMasthead: ->
    console.debug 'Initializing masthead...'
    document.ontouchmove = (e) -> e.preventDefault()
    $(document).ready -> resizeMasthead()
    $(window).resize -> resizeMasthead()
    console.debug 'done!'

  init: ->
    console.debug 'Initializing core...'
    lib.ensureFullPage()
    $(document).ready -> $('.container').addClass('affix-header')
    console.debug 'done!'
