define [
  'backbone'
  'budget/routers/server'
], (Backbone, ServerRouter) ->

  class Projection extends Backbone.Model

    urlRoot: ServerRouter.Projections.create().url

    idAttribute: "guid"
