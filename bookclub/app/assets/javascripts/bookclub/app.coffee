define [
  'jquery'
  'backbone'
  'lib'
  'data'
  'routers/client'
  'utils/view-el'
  'collections/notes'
  'models/note'
], ($, Backbone, Lib, Data, Router, ViewEl, Notes, Note) ->

  class App

    constructor: ->
      @router = new Router app: @

    mainEl: new ViewEl $("#main")

    user: Data.user

    nextPageQuery: Data.nextPageQuery

    initialNotes: new Notes Data.initialNotes

    currentNote: new Note Data.currentNote if Data.currentNote

    lastNote: new Note Data.lastNote if Data.lastNote

    init: ->
      Lib.ensureFullPage()

      Backbone.history.start
        pushState: true, root: "book-club"
