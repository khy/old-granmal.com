define [
  'jquery'
  'module'
  'lib/page'
  'lib/view-el'
  'router/client'
], ($, module, Page, ViewEl, Router) ->

  config = module.config()

  class App

    constructor: ->
      @router = new Router app: @

    mainEl: new ViewEl $("#main")

    account: config.account

    init: ->
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start pushState: true
