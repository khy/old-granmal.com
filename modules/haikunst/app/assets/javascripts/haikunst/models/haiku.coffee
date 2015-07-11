define [
  'backbone'
  'haikunst/routers/server'
], (Backbone, ServerRouter) ->

  class Haiku extends Backbone.Model

    urlRoot: ServerRouter.create().url

    idAttribute: "guid"
