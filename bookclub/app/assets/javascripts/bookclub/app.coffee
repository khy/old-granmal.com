define [
  'jquery'
  'backbone'
  'module'
  'lib/page'
  'bookclub/routers/client'
  'bookclub/utils/view-el'
  'bookclub/collections/notes'
  'bookclub/models/note'
], ($, Backbone, module, Page, Router, ViewEl, Notes, Note) ->

  config = module.config()

  class App

    constructor: ->
      @router = new Router app: @

    mainEl: new ViewEl $("#main")

    user: config.user

    nextPageQuery: config.nextPageQuery

    initialNotes: new Notes config.initialNotes

    currentNote: new Note config.currentNote if config.currentNote

    lastNote: new Note config.lastNote if config.lastNote

    init: ->
      Page.ensureFullPage()

      Backbone.history.start
        pushState: true, root: "book-club"
