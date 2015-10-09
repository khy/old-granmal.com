define [
  'backbone'
  'budget/models/planned-transaction'
], (Backbone, PlannedTransaction) ->

  class PlannedTransactions extends Backbone.Collection

    model: PlannedTransaction
