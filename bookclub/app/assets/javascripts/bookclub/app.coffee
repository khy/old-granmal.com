define ['jquery', 'backbone', 'bookclub/router'], ($, Backbone, Router) ->

  router: new Router

  init: ->
    Backbone.history.start
      pushState: true, root: "book-club"
