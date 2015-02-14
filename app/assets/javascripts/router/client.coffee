define [
  'backbone'
  'views/masthead'
], (Backbone, Masthead) ->

  class ClientRouter extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      '' :       'masthead'
      'sign-in': 'signIn'
      'sign-up': 'signUp'

    masthead: ->
      view = new Masthead app: @app
      @app.mainEl.replace(view)

    signIn: ->
      auth = @app.authView
      auth.setView auth.signIn
      @app.mainEl.replace auth

    signUp: ->
      auth = @app.authView
      auth.setView auth.signUp
      @app.mainEl.replace auth
