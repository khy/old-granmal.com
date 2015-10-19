define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/alert'
  'text!budget/templates/index.hbs'
  'budget/views/new-planned-transaction'
  'budget/views/new-transaction'
  'budget/views/new-transfer'
  'budget/views/confirm-planned-transaction'
], (
  $, _, Backbone, Handlebars, Moment, ElManager, Alert, template,
  NewPlannedTransaction, NewTransaction, NewTransfer, ConfirmPlannedTransaction
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
        .sort (a, b) -> Moment(a.get('minTimestamp')).isAfter(Moment(b.get('minTimestamp')))
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
        projectionDate: Moment(@app.projections[0].date).format('M/D')
        projections: @app.projections

      @

    events:
      'click a.new-planned-transaction': 'newPlannedTransaction'
      'click a.new-transaction': 'newTransaction'
      'click a.new-transfer': 'newTransfer'
      'click a.confirm-planned-transaction': 'confirmPlannedTransaction'

    newPlannedTransaction: (e) ->
      e?.preventDefault()

      newPlannedTransaction = new NewPlannedTransaction app: @app

      closeNewPlannedTransaction = => @setView @

      @listenTo newPlannedTransaction, 'close', closeNewPlannedTransaction

      @listenTo newPlannedTransaction, 'create', (plannedTransaction) ->
        @app.plannedTransactions.unshift plannedTransaction
        Alert.success "Created new planned transaction."
        closeNewPlannedTransaction()

      @setView newPlannedTransaction

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

    newTransfer: (e) ->
      e?.preventDefault()

      newTransfer = new NewTransfer app: @app

      closeNewTransfer = => @setView @

      @listenTo newTransfer, 'close', closeNewTransfer

      @listenTo newTransfer, 'create', (transfer) ->
        @app.transactions.unshift [transfer.get('fromTransaction'), transfer.get('toTransaction')]
        Alert.success "Created new transfer."
        closeNewTransfer()

      @setView newTransfer

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
