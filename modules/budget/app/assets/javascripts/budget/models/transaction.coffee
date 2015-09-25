define [
  'backbone'
  'budget/routers/server'
], (Backbone, ServerRouter) ->

  class Transaction extends Backbone.Model

    urlRoot: ServerRouter.Transactions.create().url

    idAttribute: "guid"
