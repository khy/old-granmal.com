define [
  'backbone'
  'budget/models/transaction'
], (Backbone, Transaction) ->

  class Transaction extends Backbone.Collection

    model: Transaction
