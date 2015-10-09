define [
  'backbone'
  'budget/routers/server'
], (Backbone, ServerRouter) ->

  class PlannedTransaction extends Backbone.Model

    urlRoot: ServerRouter.PlannedTransactions.create().url

    idAttribute: "guid"
