define [
  'jquery'
  'backbone'
  'data'
  'lib/page'
  'routers/client'
  'utils/view-el'
  'collections/notes'
  'models/note'
], ($, Backbone, Data, Page, Router, ViewEl, Notes, Note) ->

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
      Page.ensureFullPage()

      Backbone.history.start
        pushState: true, root: "book-club"
