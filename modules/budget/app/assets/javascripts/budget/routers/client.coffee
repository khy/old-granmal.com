define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'lib/javascripts/auth/session'
  'lib/javascripts/auth/form'
  'budget/views/index'
  'budget/views/plan'
  'budget/collections/transactions'
  'budget/collections/transaction-types'
  'budget/collections/accounts'
], (
  Backbone, ElManager, Prestitial, Session, AuthForm, Index, Plan
  Transactions, TransactionTypes, Accounts
) ->

  class ClientRouter extends Backbone.Router

    initialize: (bootstrap) ->
      @el = $("#main")
      _.extend @, ElManager

      @showPrestitial = true

      @session = new Session bootstrap.account
      @transactions = new Transactions bootstrap.transactions
      @transactionTypes = new TransactionTypes bootstrap.transactionTypes
      @accounts = new Accounts bootstrap.accounts
      @accountTypes = bootstrap.accountTypes

      @index = new Index app: @
      @plan = new Plan app: @

    routes:
      '': 'index'
      'plan': 'plan'

    index: ->
      @_render =>
        @setView @index

    plan: ->
      @_render =>
        @setView @plan

    _render: (render) ->
      if @showPrestitial
        prestitial = new Prestitial el: @el
        @listenTo prestitial, 'continue', ->
          @showPrestitial = false
          @_render render
        @setView prestitial
      else if !@session.isSignedIn()
        authForm = new AuthForm
          session: @session
          formError: "You must sign-in or sign-up to use Budget."

        @listenTo authForm, 'close', -> @_render render
        @listenToOnce @session, 'create', -> @_render render

        @setView authForm
      else
        render()
