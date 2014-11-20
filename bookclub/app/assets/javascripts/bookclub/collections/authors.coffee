define [
  'backbone'
  'models/author'
  'routers/server'
], (Backbone, Author, ServerRouter) ->

  class Authors extends Backbone.Collection

    model: Author

    url: ServerRouter.findAuthors().url
