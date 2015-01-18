define [
  'jquery'
  'backbone'
  'routers/client'
  'utils/view-el'
  'views/new-note'
], ($, Backbone, Router, ViewEl, NewNote) ->

  class App
    constructor: (data) ->
      @router = new Router app: @
      @user = data.user
      @initialNotes = data.initialNotes
      @currentNote = data.currentNote
      @lastNote = data.lastNote

    mainEl: new ViewEl $("#main")

    newNoteView: ->
      new NewNote lastNote: @lastNote, router: @router

    init: ->
      Backbone.history.start
        pushState: true, root: "book-club"
