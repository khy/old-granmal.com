define [
  'jquery'
  'backbone'
  'lib/page'
  'lib/view-el'
  'bookclub/routers/client'
  'bookclub/collections/notes'
  'bookclub/models/note'
], ($, Backbone, module, Page, ViewEl, Router, Notes, Note) ->

  class App

    constructor: (bootstrap) ->
      @bootstrap = bootstrap
      @router = new Router app: @

    mainEl: new ViewEl $("#main")

    user: @bootstrap.user

    nextPageQuery: @bootstrap.nextPageQuery

    initialNotes: new Notes @bootstrap.initialNotes

    currentNote: new Note @bootstrap.currentNote if @bootstrap.currentNote

    lastNote: new Note @bootstrap.lastNote if @bootstrap.lastNote

    init: ->
      $(document).ready ->
        Page.ensureFullPage()
        Backbone.history.start root: "book-club", pushState: true
