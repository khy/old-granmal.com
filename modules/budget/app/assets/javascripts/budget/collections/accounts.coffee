define [
  'backbone'
  'budget/models/account'
], (Backbone, Account) ->

  class Accounts extends Backbone.Collection

    model: Account
