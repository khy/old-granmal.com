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
  'budget/collections/transactions'
  'budget/views/new-account'
  'budget/collections/accounts'
  'budget/views/new-transaction-type'
  'budget/collections/transaction-types'
], ($, _, Backbone, Handlebars, Moment, ElManager, Alert, template, NewTransaction,
    Transactions, NewAccount, Accounts, NewTransactionType, TransactionTypes) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @router = opts.router
      @session = opts.session
      @transactions = new Transactions opts.transactions
      @accounts = new Accounts opts.accounts
      @transactionTypes = new TransactionTypes opts.transactionTypes
      @accountTypes = opts.accountTypes

    render: ->
      @$el.html Index.template
        transactions: @transactions.map (transaction) =>
          account = @accounts.get(transaction.get('accountGuid'))
          transactionType = @transactionTypes.get(transaction.get('transactionTypeGuid'))

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

    newTransaction: (e) ->
      e?.preventDefault()
      newTransaction = new NewTransaction
        accounts: @accounts
        transactionTypes: @transactionTypes

      closeNewTransaction = =>
        @setView @
        @router.navigate("")

      @listenTo newTransaction, 'close', closeNewTransaction

      @listenTo newTransaction, 'create', (transaction) ->
        @transactions.unshift transaction
        Alert.success "Created new transaction."
        closeNewTransaction()

      @setView newTransaction
      @router.navigate("transactions/new")

    newAccount: (e) ->
      e?.preventDefault()
      newAccount = new NewAccount
        accountTypes: @accountTypes

      closeNewAccount = =>
        @setView @
        @router.navigate("")

      @listenTo newAccount, 'close', closeNewAccount

      @listenTo newAccount, 'create', (account) ->
        @accounts.unshift account
        Alert.success "Created new #{account.get('accountType')} account \"#{account.get('name')}\""
        closeNewAccount()

      @setView newAccount
      @router.navigate("accounts/new")

    newTransactionType: (e) ->
      e?.preventDefault()
      newTransactionType = new NewTransactionType
        transactionTypes: @transactionTypes

      closeNewTransactionType = =>
        @setView @
        @router.navigate("")

      @listenTo newTransactionType, 'close', closeNewTransactionType

      @listenTo newTransactionType, 'create', (transactionType) ->
        @transactionTypes.unshift transactionType
        Alert.success "Created new transaction type \"#{transactionType.get('name')}\""
        closeNewTransactionType()

      @setView newTransactionType
      @router.navigate("transactionTypes/new")
