define [
  'jquery'
  'backbone'
  'module'
  'lib/page'
  'lib/view-el'
  'router/client'
  'utils/session'
  'views/sign-in'
], ($, Backbone, module, Page, ViewEl, Router, Session, SignIn) ->

  config = module.config()

  class App

    constructor: ->
      @router = new Router app: @
      @session = new Session config.account
      @signInForm = new SignIn session: @session

    mainEl: new ViewEl $("#main")

    init: ->
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start pushState: true
