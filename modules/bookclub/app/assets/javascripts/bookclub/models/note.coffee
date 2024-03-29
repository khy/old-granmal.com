define [
  'backbone'
  'bookclub/routers/server'
], (Backbone, ServerRouter) ->

  class Note extends Backbone.Model

    urlRoot: ServerRouter.createNote().url

    idAttribute: "guid"
