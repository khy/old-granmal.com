define ['jquery', 'backbone', 'bookclub/router'], ($, Backbone, Router) ->

  class App
    constructor: ->
      @router = new Router app: @

    mainEl: $("#main")

    init: ->
      Backbone.history.start
        pushState: true, root: "book-club"
