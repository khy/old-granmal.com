define [
  'backbone'
  'budget/models/transaction'
], (Backbone, Transaction) ->

  class Transactions extends Backbone.Collection

    model: Transaction
