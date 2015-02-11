define [
  'jquery'
  'backbone'
  'module'
  'lib/page'
  'lib/view-el'
  'router/client'
  'views/sign-in'
], ($, Backbone, module, Page, ViewEl, Router, SignIn) ->

  config = module.config()

  class App extends Backbone.Events

    constructor: ->
      @router = new Router app: @

      @account = config.account

      @signInForm = new SignIn app: @
      @signInForm.on 'signIn', @setAccount

    setAccount: (account) -> @account = account

    mainEl: new ViewEl $("#main")

    init: ->
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start pushState: true
