define [
  'backbone'
  'bookclub/models/author'
  'bookclub/routers/server'
], (Backbone, Author, ServerRouter) ->

  class Authors extends Backbone.Collection

    model: Author

    url: ServerRouter.findAuthors().url
