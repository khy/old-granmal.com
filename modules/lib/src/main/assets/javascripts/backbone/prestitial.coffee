define [
  'jquery'
  'backbone'
], ($, Backbone) ->

  class Prestitial extends Backbone.View

    initialize: (opts) ->
      continueEl = $('<a href="#" class="continue">Continue</a>')
      @$el.find(".loading").replaceWith(continueEl)

    events:
      'click a.continue': 'triggerContinue'

    triggerContinue: (e) ->
      e.preventDefault()
      @trigger 'continue'
