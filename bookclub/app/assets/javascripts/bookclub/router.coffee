define ['backbone', 'bookclub/views/new-note'], (Backbone, NewNote) ->

  class Router extends Backbone.Router

    initialize: (options) ->
      @app = options.app

    routes:
      'notes/new': 'newNote'

    newNote: ->
      view = new NewNote(el: @app.mainEl)
      view.render()
