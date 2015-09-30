define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/alert'
  'text!budget/templates/plan.hbs'
  'budget/views/new-transaction'
], (
  $, _, Backbone, Handlebars, Moment, ElManager, Alert, template, NewTransaction
) ->

  class Plan extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @app = opts.app

    render: ->
      transactions = @app.transactions
        .filter (transaction) -> Moment(transaction.get('timestamp')).isAfter(new Date)
        .sort (a, b) -> Moment(a.get('timestamp')).isAfter(b.get('timestamp'))

      @$el.html Plan.template
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

    events:
      'click a.new-transaction': 'newTransaction'

    newTransaction: (e) ->
      e?.preventDefault()

      newTransaction = new NewTransaction app: @app

      closeNewTransaction = => @setView @

      @listenTo newTransaction, 'close', closeNewTransaction

      @listenTo newTransaction, 'create', (transaction) ->
        @app.transactions.unshift transaction
        Alert.success "Created new transaction."
        closeNewTransaction()

      @setView newTransaction
