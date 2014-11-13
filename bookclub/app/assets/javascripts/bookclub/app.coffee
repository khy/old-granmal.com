define ['jquery', 'backbone', 'router'], ($, Backbone, Router) ->

  class App
    constructor: (data) ->
      @router = new Router app: @
      @lastNote = data.lastNote

    mainEl: $("#main")

    init: ->
      Backbone.history.start
        pushState: true, root: "book-club"
