define [
  'backbone'
  'budget/routers/server'
], (Backbone, ServerRouter) ->

  class Account extends Backbone.Model

    @AccountTypes: {
      Credit: 'credit',
      Checking: 'checking',
      Savings: 'savings'
    }

    urlRoot: ServerRouter.Accounts.create().url

    idAttribute: "guid"
