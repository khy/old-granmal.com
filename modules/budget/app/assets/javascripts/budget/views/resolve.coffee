define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/backbone/el-manager'
  'text!budget/templates/resolve.hbs'
], (
  $, _, Backbone, Handlebars, Moment, ElManager, template
) ->

  class Resolve extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @app = opts.app

    render: ->
      transactions = @app.transactions
        .filter (transaction) -> Moment(transaction.get('timestamp')).isBefore(new Date)
        .sort (a, b) -> Moment(a.get('timestamp')).isAfter(b.get('timestamp'))

      @$el.html Resolve.template
        transactions: transactions.map (transaction) =>
          account = @app.accounts.get(transaction.get('accountGuid'))
          transactionType = @app.transactionTypes.get(transaction.get('transactionTypeGuid'))

          account:
            guid: account.get('guid')
            name: account.get('name')
          transactionType:
            guid: transactionType.get('guid')
            name: transactionType.get('name')
          amount:
            value: transaction.get('amount')
            class: if transaction.get('amount') >= 0 then 'amount-income' else 'amount-expense'
          date: Moment(transaction.get('timestamp')).format('MMMM Do YYYY')

      @
