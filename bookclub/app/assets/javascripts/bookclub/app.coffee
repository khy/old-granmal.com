define [
  'jquery'
  'backbone'
  'module'
  'lib/page'
  'routers/client'
  'utils/view-el'
  'collections/notes'
  'models/note'
], ($, Backbone, module, Page, Router, ViewEl, Notes, Note) ->

  data = module.config().data

  class App

    constructor: ->
      @router = new Router app: @

    mainEl: new ViewEl $("#main")

    user: data.user

    nextPageQuery: data.nextPageQuery

    initialNotes: new Notes data.initialNotes

    currentNote: new Note data.currentNote if data.currentNote

    lastNote: new Note data.lastNote if data.lastNote

    init: ->
      Page.ensureFullPage()

      Backbone.history.start
        pushState: true, root: "book-club"
