define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/alert'
  'text!budget/templates/index.hbs'
  'budget/views/new-transaction'
  'budget/views/confirm-planned-transaction'
], (
  $, _, Backbone, Handlebars, Moment, ElManager, Alert, template, NewTransaction,
  ConfirmPlannedTransaction
) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @app = opts.app

    render: ->
      upcomingTransactions = @app.plannedTransactions.models
        .filter (transaction) -> Moment(transaction.get('minTimestamp')).isAfter(new Date)

      pendingTransactions = @app.plannedTransactions.models
        .filter (transaction) ->
          Moment(transaction.get('minTimestamp')).isBefore(new Date) &&
          typeof transaction.get('transactionGuid') != 'string'

      preparePlannedTransactions = (plannedTransactions) =>
        plannedTransactions
          .sort (a, b) -> Moment(a.get('minTimestamp')).isAfter(b.get('minTimestamp'))
          .map (plannedTransaction) =>
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

      recentTransactions = @app.transactions.models
        .sort (a, b) -> Moment(b.get('minTimestamp')).isAfter(a.get('minTimestamp'))
        .map (transaction) =>
          account = @app.accounts.get(transaction.get('accountGuid'))
          transactionType = @app.transactionTypes.get(transaction.get('transactionTypeGuid'))

          guid: transaction.get('guid')
          account:
            guid: account.get('guid')
            name: account.get('name')
          transactionType:
            guid: transactionType.get('guid')
            name: transactionType.get('name')
          amount:
            value: transaction.get('amount')
            class: if transaction.get('amount') >= 0 then 'amount-income' else 'amount-expense'
          date: Moment(transaction.get('timestamp')).format('M/D')

      transactionGroups = @app.plannedTransactions.groupBy (plannedTransaction) ->
        plannedTransaction.get('accountGuid')

      @$el.html Index.template
        upcomingTransactions: preparePlannedTransactions(upcomingTransactions)
        pendingTransactions: preparePlannedTransactions(pendingTransactions)
        recentTransactions: recentTransactions
        projectedBalances: @app.accounts.models.map (account) =>
          transactionTotal = @app.transactions.models
            .filter (transaction) -> transaction.get('accountGuid') == account.get('guid')
            .map (transaction) -> transaction.get('amount')
            .reduce (total, amount) ->
              total + amount
            , 0

          plannedTransactionTotal = @app.plannedTransactions.models
            .filter (plannedTransaction) ->
              plannedTransaction.get('accountGuid') == account.get('guid') &&
              typeof plannedTransaction.get('transactionGuid') != 'string'
            .map (plannedTransaction) -> plannedTransaction.get('minAmount')
            .reduce (total, amount) ->
              total + amount
            , 0

          account:
            guid: account.get('guid')
            name: account.get('name')
          currentBalance:
            value: account.get('initialBalance') + transactionTotal
          projectedBalance:
            value: account.get('initialBalance') + transactionTotal + plannedTransactionTotal

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
      plannedTransaction = @app.plannedTransactions.get(guid)
      confirmPlannedTransaction = new ConfirmPlannedTransaction plannedTransaction, @app

      closeConfirmPlannedTransaction = => @setView @

      @listenTo confirmPlannedTransaction, 'close', closeConfirmPlannedTransaction

      @listenTo confirmPlannedTransaction, 'create', (transaction) ->
        @app.transactions.unshift transaction
        Alert.success "Created new transaction."
        closeConfirmPlannedTransaction()

      @setView confirmPlannedTransaction
