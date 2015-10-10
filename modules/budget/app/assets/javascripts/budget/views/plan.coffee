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
  'budget/views/confirm-planned-transaction'
], (
  $, _, Backbone, Handlebars, Moment, ElManager, Alert, template, NewTransaction,
  ConfirmPlannedTransaction
) ->

  class Plan extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @app = opts.app

    render: ->
      plannedTransactions = @app.plannedTransactions.models
        # .filter (transaction) -> Moment(transaction.get('timestamp')).isAfter(new Date)
        .sort (a, b) -> Moment(a.get('minTimestamp')).isAfter(b.get('minTimestamp'))

      transactionGroups = @app.plannedTransactions.groupBy (plannedTransaction) ->
        plannedTransaction.get('accountGuid')

      @$el.html Plan.template
        plannedTransactions: plannedTransactions.map (plannedTransaction) =>
          account = @app.accounts.get(plannedTransaction.get('accountGuid'))
          transactionType = @app.transactionTypes.get(plannedTransaction.get('transactionTypeGuid'))

          guid: plannedTransaction.get('guid')
          account:
            guid: account.get('guid')
            name: account.get('name')
          transactionType:
            guid: transactionType.get('guid')
            name: transactionType.get('name')
          amount:
            value: plannedTransaction.get('minAmount')
            class: if plannedTransaction.get('minAmount') >= 0 then 'amount-income' else 'amount-expense'
          date: Moment(plannedTransaction.get('minTimestamp')).format('M/D')
        projectedBalances: _.map transactionGroups, (plannedTransactions, accountGuid) =>
          account = @app.accounts.get(accountGuid)
          transactionTotal = plannedTransactions
            .map (plannedTransaction) -> plannedTransaction.get('minAmount')
            .reduce (memo, amount) -> memo + amount

          account:
            guid: account.get('guid')
            name: account.get('name')
          currentBalance:
            value: account.get('initialBalance')
          projectedBalance:
            value: account.get('initialBalance') + transactionTotal

      @

    events:
      'click a.new-transaction': 'newTransaction'
      'click a.confirm-planned-transaction': 'confirmPlannedTransaction'

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

    confirmPlannedTransaction: (e) ->
      e?.preventDefault()

      guid = $(e.target).data("guid")
      console.log guid
      plannedTransaction = @app.plannedTransactions.get(guid)
      console.log plannedTransaction
      confirmPlannedTransaction = new ConfirmPlannedTransaction plannedTransaction, @app

      closeConfirmPlannedTransaction = => @setView @

      @listenTo confirmPlannedTransaction, 'close', closeConfirmPlannedTransaction

      @listenTo confirmPlannedTransaction, 'create', (transaction) ->
        @app.transactions.unshift transaction
        Alert.success "Created new transaction."
        closeConfirmPlannedTransaction()

      @setView confirmPlannedTransaction
