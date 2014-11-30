define [
  'backbone'
  'models/book'
  'routers/server'
], (Backbone, Book, ServerRouter) ->

  class Books extends Backbone.Collection

    model: Book

    url: ServerRouter.findBooks().url
