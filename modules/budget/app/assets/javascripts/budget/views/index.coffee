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
  'budget/views/new-account'
  'budget/views/new-transaction-type'
], (
  $, _, Backbone, Handlebars, Moment, ElManager, Alert, template,
  NewTransaction, NewAccount, NewTransactionType
) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @app = opts.app

    render: ->
      @$el.html Index.template
      @

    events:
      'click a.plan': 'showPlan'

    showPlan: (e) ->
      e?.preventDefault()
      @app.navigate "plan", trigger: true

    newTransaction: (e) ->
      e?.preventDefault()
      newTransaction = new NewTransaction
        accounts: @app.accounts
        transactionTypes: @app.transactionTypes

      closeNewTransaction = =>
        @setView @
        @app.navigate("")

      @listenTo newTransaction, 'close', closeNewTransaction

      @listenTo newTransaction, 'create', (transaction) ->
        @app.transactions.unshift transaction
        Alert.success "Created new transaction."
        closeNewTransaction()

      @setView newTransaction
      @app.navigate("transactions/new")

    newAccount: (e) ->
      e?.preventDefault()
      newAccount = new NewAccount
        accountTypes: @app.accountTypes

      closeNewAccount = =>
        @setView @
        @app.navigate("")

      @listenTo newAccount, 'close', closeNewAccount

      @listenTo newAccount, 'create', (account) ->
        @app.accounts.unshift account
        Alert.success "Created new #{account.get('accountType')} account \"#{account.get('name')}\""
        closeNewAccount()

      @setView newAccount
      @app.navigate("accounts/new")

    newTransactionType: (e) ->
      e?.preventDefault()
      newTransactionType = new NewTransactionType
        transactionTypes: @app.transactionTypes

      closeNewTransactionType = =>
        @setView @
        @app.navigate("")

      @listenTo newTransactionType, 'close', closeNewTransactionType

      @listenTo newTransactionType, 'create', (transactionType) ->
        @app.transactionTypes.unshift transactionType
        Alert.success "Created new transaction type \"#{transactionType.get('name')}\""
        closeNewTransactionType()

      @setView newTransactionType
      @app.navigate("transactionTypes/new")
