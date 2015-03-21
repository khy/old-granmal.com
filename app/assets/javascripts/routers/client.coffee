define [
  'jquery'
  'underscore'
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/auth/session'
  'lib/javascripts/auth/form'
  'views/apps'
  'routers/server'
], ($, _, Backbone, ElManager, Session, AuthForm, Apps, ServerRouter) ->

  class ClientRouter extends Backbone.Router

    initialize: (config) ->
      @el = $("#main")
      _.extend @, ElManager

      @session = new Session config.account
      @appsView = new Apps session: @session, router: @

    routes:
      '' :       'apps'
      'sign-in': 'signIn'
      'sign-up': 'signUp'
      '*path':   'apps'

    apps: -> @setView @appsView

    signIn: -> @auth 'signIn'

    signUp: -> @auth 'signUp'

    auth: (view) ->
      authView = new AuthForm session: @session, router: @
      authView.view = authView[view]

      @listenToOnce authView, 'close', =>
        @setView @appsView
        @navigate ''

      @setView authView
