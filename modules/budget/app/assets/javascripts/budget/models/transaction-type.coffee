define [
  'backbone'
  'budget/routers/server'
], (Backbone, ServerRouter) ->

  class TransactionType extends Backbone.Model

    urlRoot: ServerRouter.TransactionTypes.create().url

    idAttribute: "guid"
