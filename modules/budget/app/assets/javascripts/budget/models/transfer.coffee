define [
  'backbone'
  'budget/routers/server'
], (Backbone, ServerRouter) ->

  class Transfer extends Backbone.Model

    urlRoot: ServerRouter.Transfers.create().url

    idAttribute: "guid"
