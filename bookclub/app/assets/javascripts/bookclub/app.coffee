define [
  'jquery'
  'backbone'
  'routers/client'
  'utils/view-el'
  'views/show-note'
  'views/new-note'
], ($, Backbone, Router, ViewEl, ShowNote, NewNote) ->

  class App
    constructor: (data) ->
      @router = new Router app: @
      @user = data.user
      @initialNotes = data.initialNotes
      @currentNote = data.currentNote
      @lastNote = data.lastNote

    mainEl: new ViewEl $("#main")

    showNoteView: (note) ->
      new ShowNote note: note

    newNoteView: ->
      new NewNote lastNote: @lastNote, router: @router

    init: ->
      Backbone.history.start
        pushState: true, root: "book-club"
