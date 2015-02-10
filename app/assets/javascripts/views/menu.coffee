define [
  'backbone'
  'handlebars'
  'text!templates/menu.hbs'
], (Backbone, Handlebars, template) ->

  class Menu extends Backbone.View

    initialize: (opts) ->
      @app = opts.app

    @template: Handlebars.compile template

    render: ->
      @$el.html Menu.template account: @app.account
      @

    events:
      'click a.close': 'close'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
