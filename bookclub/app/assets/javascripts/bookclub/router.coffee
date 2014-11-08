define ['backbone'], (Backbone) ->

  class Router extends Backbone.Router

    routes:
      'notes/new': 'newNote'

    newNote: -> console.debug("newNote")
