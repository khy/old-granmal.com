define ['jquery', 'backbone', 'routers/client'], ($, Backbone, ClientRouter) ->

  class App
    constructor: (data) ->
      @router = new ClientRouter app: @
      @user = data.user
      @lastNote = data.lastNote

    mainEl: $("#main")

    init: ->
      Backbone.history.start
        pushState: true, root: "book-club"
