define [
  'backbone'
  'bookclub/models/book'
  'bookclub/routers/server'
], (Backbone, Book, ServerRouter) ->

  class Books extends Backbone.Collection

    model: Book

    url: ServerRouter.findBooks().url
