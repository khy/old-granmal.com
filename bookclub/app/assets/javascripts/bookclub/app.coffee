define [
  'jquery'
  'backbone'
  'routers/client'
], ($, Backbone, Router) ->

  class App
    constructor: (data) ->
      @router = new Router app: @
      @user = data.user
      @initialNotes = data.initialNotes
      @currentNote = data.currentNote
      @lastNote = data.lastNote

    mainEl: $("#main")

    init: ->
      Backbone.history.start
        pushState: true, root: "book-club"
