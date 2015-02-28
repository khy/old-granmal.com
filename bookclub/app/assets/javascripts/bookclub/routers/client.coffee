define [
  'backbone'
  'bookclub/views/index'
  'bookclub/views/show-note'
  'bookclub/views/new-note'
  'bookclub/routers/server'
], (Backbone, Index, ShowNote, NewNote, ServerRouter) ->

  class ClientRouter extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      ''            : 'index'
      'notes/new'   : 'newNote'
      'notes/:guid' : 'showNote'

    index: ->
      view = new Index collection: @app.initialNotes, app: @app
      @app.mainEl.replace(view)

    newNote: ->
      if @app.user
        view = @app.newNoteView()
        @app.mainEl.replace view
      else
        window.location.replace(ServerRouter.signIn().url)

    showNote: (opts) ->
      view = if @app.currentNote?.get("guid") == opts.guid
        new ShowNote note: @app.currentNote
      else
        new ShowNote opts

      @app.mainEl.replace view
