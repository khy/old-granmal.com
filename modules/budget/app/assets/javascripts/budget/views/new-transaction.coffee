define [
  'jquery'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/transaction'
  'text!budget/templates/new-transaction.hbs'
], ($, Backbone, Handlebars, Moment, ElManager, Check, Transaction, template) ->

  class NewTransaction extends Backbone.View

    @template: Handlebars.compile(template)

    @parseDate: (raw) -> Moment(raw, "MM|DD|YYYY")

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

      console.log NewTransaction.parseDate(@input.date)

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
