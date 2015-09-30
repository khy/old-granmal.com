define [
  'jquery'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/alert'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/transaction'
  'text!budget/templates/new-transaction.hbs'
  'budget/views/new-transaction-type'
  'budget/views/new-account'
], (
  $, Backbone, Handlebars, Moment, Alert, ElManager, Check, Transaction,
  template, NewTransactionType, NewAccount
) ->

  class NewTransaction extends Backbone.View

    @template: Handlebars.compile(template)

    @parseDate: (raw) -> Moment(raw, "MM|DD|YYYY")

    initialize: (opts = {}) ->
      _.extend @, ElManager
      @app = opts.app
      @input = {}
      @transaction = new Transaction

      @listenTo @transaction, 'sync', ->
        @trigger 'create', @transaction

    render: ->
      @$el.html NewTransaction.template _.extend @input,
        accountOptions: @app.accounts.map (account) =>
          _.extend account.toJSON(),
            selected: account.get('guid') == @input.accountGuid
        transactionTypeOptions: @app.transactionTypes.map (transactionType) =>
          _.extend transactionType.toJSON(),
            selected: transactionType.get('guid') == @input.transactionTypeGuid
        errors: @errors
      @

    events:
      'submit form': 'create'
      'click a.close': 'close'
      'click a.new-transaction-type': 'newTransactionType'
      'click a.new-account': 'newAccount'

    create: (e) ->
      e?.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        jqxhr = @transaction.save _.extend @input,
          timestamp: NewTransaction.parseDate(@input.date).toISOString()

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseErrors jqxhr.responseJSON
            @render()

      else
        @render()

    getInput: ->
      accountGuid: @$('select[name="accountGuid"]').val()
      transactionTypeGuid: @$('select[name="transactionTypeGuid"]').val()
      amount: @$('input[name="amount"]').val()
      date: @$('input[name="date"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.amount)
        errors.amount = 'Amount is required.'

      if Check.isMissing(input.date)
        errors.date = 'Date is required.'
      else if !NewTransaction.parseDate(input.date).isValid()
        errors.date = 'Date is invalid. Try something like \'3/15/16\' or \'10-31-17\''

      errors

    parseResponseError: (errors) ->
      errors = {}
      errors

    close: (e) ->
      e?.preventDefault()
      @trigger 'close'

    newTransactionType: (e) ->
      e?.preventDefault()

      newTransactionType = new NewTransactionType app: @app

      closeNewTransactionType = => @setView @

      @listenTo newTransactionType, 'close', closeNewTransactionType

      @listenTo newTransactionType, 'create', (transactionType) ->
        @app.transactionTypes.unshift transactionType
        Alert.success "Created new transaction type \"#{transactionType.get('name')}\""
        closeNewTransactionType()

      @setView newTransactionType

    newAccount: (e) ->
      e?.preventDefault()
      newAccount = new NewAccount app: @app

      closeNewAccount = =>
        @setView @

      @listenTo newAccount, 'close', closeNewAccount

      @listenTo newAccount, 'create', (account) ->
        @app.accounts.unshift account
        Alert.success "Created new #{account.get('accountType')} account \"#{account.get('name')}\""
        closeNewAccount()

      @setView newAccount
