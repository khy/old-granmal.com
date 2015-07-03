define ['jquery', 'underscore'], ($, _) ->

  # Adapted from https://medium.com/@mariusc23/hide-header-on-scroll-down-show-on-scroll-up-67bbaae9a78c
  seVisibilityFn = ->
    lastScrollTop = 0

    ->
      header = $('header, .header')

      if header.length > 0
        scrollTop = $(window).scrollTop()

        # Do nothing if the page hasn't scrolled enough
        if Math.abs(lastScrollTop - scrollTop) <= 10
          return

        # If the page scrolled down, past the bottom of the header...
        if (scrollTop > lastScrollTop and scrollTop > header.outerHeight())
          header.addClass 'hidden'
        else
          # Prevents showing the header if you scroll past the document in Safari
          if (scrollTop + $(window).height() < $(document).height() - 1)
            header.removeClass 'hidden'

        lastScrollTop = scrollTop

  init: ->
    $(window).scroll _.throttle seVisibilityFn(), 250
