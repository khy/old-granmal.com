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
        el: @app.mainEl
        initialNotes: @app.initialNotes
        router: @app.router

      view.render()

    newNote: ->
      console.log("NEW NOTE")
      if @app.user
        view = new NewNote(el: @app.mainEl, lastNote: @app.lastNote)
        view.render()
      else
        window.location.replace(ServerRouter.signIn().url)

    showNote: (guid) ->
      view = if @app.currentNote?.get("guid") == guid
        new ShowNote(el: @app.mainEl, note: @app.currentNote)
      else
        new ShowNote(el: @app.mainEl, guid: guid)

      view.render()
