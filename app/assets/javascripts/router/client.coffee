define [
  'backbone'
  'views/masthead'
], (Backbone, Masthead) ->

  class ClientRouter extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      '' : 'masthead'

    masthead: ->
      view = new Masthead app: @app
      @app.mainEl.replace(view)
