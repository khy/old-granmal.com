define ['jquery'], ($) ->

  conditionallyAffixHeader: (threshold) ->
    if ($(window).scrollTop() >= threshold)
      $('.container').addClass('affix-header')
    else
      $('.container').removeClass('affix-header')
