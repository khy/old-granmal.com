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
      'notes/new'   : 'newNote'
      'notes/:guid' : 'showNote'

    index: ->
      view = new Index
        initialNotes: @app.initialNotes
        router: this

      @app.mainEl.insertView(view)

    newNote: ->
      if @app.user
        view = new NewNote lastNote: @app.lastNote
        @app.mainEl.insertView(view)
      else
        window.location.replace(ServerRouter.signIn().url)

    showNote: (guid) ->
      view = if @app.currentNote?.get("guid") == guid
        new ShowNote note: @app.currentNote
      else
        new ShowNote guid: guid

      @app.mainEl.insertView(view)
