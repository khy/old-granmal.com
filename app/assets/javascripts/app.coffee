define [
  'jquery'
  'backbone'
  'module'
  'lib/page'
  'lib/view-el'
  'routers/client'
  'utils/session'
  'views/auth'
], ($, Backbone, module, Page, ViewEl, Router, Session, Auth) ->

  config = module.config()

  class App

    constructor: ->
      @router = new Router app: @
      @session = new Session config.account
      @authView = new Auth session: @session, router: @router

    mainEl: new ViewEl $("#main")

    init: ->
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start pushState: true
