define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/transaction'
  'text!budget/templates/new-transaction.hbs'
], ($, Backbone, Handlebars, ElManager, Check, Transaction, template) ->

  class NewTransaction extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager
      @input = {}
      @transaction = new Transaction
      @accounts = opts.accounts
      @transactionTypes = opts.transactionTypes

      @listenTo @transaction, 'sync', ->
        @trigger 'create', @transaction

    render: ->
      @$el.html NewTransaction.template _.extend @input,
        accountOptions: @accounts.map (account) =>
          _.extend account.toJSON(),
            selected: account.get('guid') == @input.accountGuid
        transactionTypeOptions: @transactionTypes.map (transactionType) =>
          _.extend transactionType.toJSON(),
            selected: transactionType.get('guid') == @input.transactionTypeGuid
        errors: @errors
      @

    events:
      'submit form': 'create'
      'click a.close': 'close'

    create: (e) ->
      e?.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        jqxhr = @transaction.save @input

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseErrors jqxhr.responseJSON
            @render()

      else
        @render()

    getInput: ->
      parentGuid: @$('select[name="accountGuid"]').val()
      parentGuid: @$('select[name="transactionTypeGuid"]').val()
      amount: @$('input[name="amount"]').val()
      timestamp: @$('input[name="date"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.amount)
        errors.amount = 'Amount is required.'

      if Check.isMissing(input.timestamp)
        errors.date = 'Date is required.'

      errors

    parseResponseError: (errors) ->
      errors = {}
      errors

    close: (e) ->
      e?.preventDefault()
      @trigger 'close'
