define [
  'jquery'
  'backbone'
  'lib/javascripts/view-el'
  'utils/session'
  'views/masthead'
  'views/apps'
  'views/auth'
], ($, Backbone, ViewEl, Session, Masthead, Apps, Auth) ->

  class ClientRouter extends Backbone.Router

    initialize: (config) ->
      @mainEl = new ViewEl $("#main")
      @session = new Session config.account
      @appsView = new Apps mainEl: @mainEl, session: @session, router: @

    routes:
      '' :       'masthead'
      'sign-in': 'signIn'
      'sign-up': 'signUp'
      '*path':   'apps'

    masthead: ->
      view = new Masthead mainEl: @mainEl, session: @session, router: @
      @mainEl.replace(view)

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
