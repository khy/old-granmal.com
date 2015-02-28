define [
  'jquery'
  'underscore'
  'backbone'
  'lib/javascripts/el-manager'
  'utils/session'
  'views/masthead'
  'views/apps'
  'views/auth'
], ($, _, Backbone, ElManager, Session, Masthead, Apps, Auth) ->

  class ClientRouter extends Backbone.Router

    initialize: (config) ->
      @el = $("#main")
      _.extend @, ElManager

      @session = new Session config.account
      @appsView = new Apps session: @session, router: @

    routes:
      '' :       'masthead'
      'sign-in': 'signIn'
      'sign-up': 'signUp'
      '*path':   'apps'

    masthead: ->
      @setView @appsView

    apps: ->
      @mainEl.replace @appsView
      @appsView.navigate()

    signIn: -> @auth 'signIn'

    signUp: -> @auth 'signUp'

    auth: (view) ->
      authView = new Auth session: @session, router: @
      authView.setView authView[view]
      @listenToOnce authView, 'close', =>
        @mainEl.replace @appsView, hard: true
        @appsView.navigate()
      @mainEl.replace authView
