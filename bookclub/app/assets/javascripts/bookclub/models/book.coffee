define [
  'underscore'
  'backbone'
  'routers/server'
], (_, Backbone, ServerRouter) ->

  class Book extends Backbone.Model

    urlRoot: ServerRouter.createBook().url

    validate: (attrs) ->
      error = {}

      if !_.isString(attrs.title) or _.isEmpty(attrs.title)
        error.title = "missing"

      if !_.isString(attrs.author_guid) or _.isEmpty(attrs.author_guid)
        error.author_guid = "missing"

      error if !_.isEmpty(error)
