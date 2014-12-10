define [
  'backbone'
  'views/index'
  'views/new-note'
  'routers/server'
], (Backbone, Index, NewNote, ServerRouter) ->

  class ClientRouter extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      ''         : 'index'
      'notes/new': 'newNote'

    index: ->
      view = new Index(el: @app.mainEl)
      view.render()

    newNote: ->
      if @app.user
        view = new NewNote(el: @app.mainEl, lastNote: @app.lastNote)
        view.render()
      else
        window.location.replace(ServerRouter.signIn().url)
