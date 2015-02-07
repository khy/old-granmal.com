define [
  'jquery'
  'backbone'
  'module'
  'lib/page'
  'lib/view-el'
  'bookclub/routers/client'
  'bookclub/collections/notes'
  'bookclub/models/note'
], ($, Backbone, module, Page, ViewEl, Router, Notes, Note) ->

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
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start root: "book-club", pushState: true
