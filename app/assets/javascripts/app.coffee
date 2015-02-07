define [
  'jquery',
  'lib/page'
  'lib/view-el'
  'router/client'
], ($, Page, ViewEl, Router) ->

  class App

    constructor: ->
      @router = new Router app: @

    mainEl: new ViewEl $("#main")

    init: ->
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start pushState: true
