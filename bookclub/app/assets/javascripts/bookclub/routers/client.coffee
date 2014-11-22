define [
  'backbone'
  'views/new-note'
  'views/new-book'
  'routers/server'
], (Backbone, NewNote, NewBook, ServerRouter) ->

  class ClientRouter extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      'notes/new': 'newNote'
      'books/new': 'newBook'

    newNote: ->
      view = new NewNote(el: @app.mainEl, lastNote: @app.lastNote)
      view.render()

    newBook: ->
      if @app.user
        view = new NewBook(el: @app.mainEl)
        view.render()
      else
        window.location.replace(ServerRouter.signIn().url)
