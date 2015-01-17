define [
  'backbone'
  'views/index'
  'views/show-note'
  'views/new-note'
  'routers/server'
], (Backbone, Index, ShowNote, NewNote, ServerRouter) ->

  class ClientRouter extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      ''            : 'index'
      'notes/new'   : '_newNote'
      'notes/:guid' : '_showNote'

    index: ->
      view = new Index collection: @app.initialNotes, router: @app.router
      @app.mainEl.insertView(view)

    newNote: -> @navigate "notes/new", trigger: true

    _newNote: ->
      if @app.user
        view = new NewNote lastNote: @app.lastNote, router: @app.router
        @app.mainEl.insertView(view)
      else
        window.location.replace(ServerRouter.signIn().url)

    showNote: (note) ->
      view = new ShowNote note: note
      @app.mainEl.insertView view
      @navigate("notes/#{note.id}")

    _showNote: (guid) ->
      view = if @app.currentNote?.get("guid") == guid
        new ShowNote note: @app.currentNote
      else
        new ShowNote guid: guid

      @app.mainEl.insertView(view)
