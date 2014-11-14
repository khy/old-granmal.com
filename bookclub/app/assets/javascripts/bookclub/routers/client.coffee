define [
  'backbone'
  'views/new-note'
  'views/new-book'
], (Backbone, NewNote, NewBook) ->

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
      view = new NewBook(el: @app.mainEl)
      view.render()
