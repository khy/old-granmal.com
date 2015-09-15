define [
  'backbone'
  'budget/models/transaction-type'
], (Backbone, TransactionType) ->

  class TransactionTypes extends Backbone.Collection

    model: TransactionType
