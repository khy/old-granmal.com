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
      view = new Masthead
      @app.mainEl.replace(view)
