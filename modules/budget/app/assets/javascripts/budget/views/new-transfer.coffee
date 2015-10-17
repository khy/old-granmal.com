define [
  'jquery'
  'backbone'
  'handlebars'
  'moment'
  'lib/javascripts/alert'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/transfer'
  'text!budget/templates/new-transfer.hbs'
  'budget/views/new-account'
], (
  $, Backbone, Handlebars, Moment, Alert, ElManager, Check, Transfer,
  template, NewAccount
) ->

  class NewTransfer extends Backbone.View

    @template: Handlebars.compile(template)

    @parseDate: (raw) -> Moment(raw, "MM|DD|YYYY")

    initialize: (opts = {}) ->
      _.extend @, ElManager
      @app = opts.app
      @input = {}
      @transfer = new Transfer

      @listenTo @transfer, 'sync', ->
        @trigger 'create', @transfer

    render: ->
      @$el.html NewTransfer.template _.extend @input,
        fromAccountOptions: @app.accounts.map (account) =>
          _.extend account.toJSON(),
            selected: account.get('guid') == @input.fromAccountGuid
        toAccountOptions: @app.accounts.map (account) =>
          _.extend account.toJSON(),
            selected: account.get('guid') == @input.toAccountGuid
        errors: @errors
      @

    events:
      'submit form': 'create'
      'click a.close': 'close'
      'click a.new-account': 'newAccount'

    create: (e) ->
      e?.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        jqxhr = @transfer.save _.extend @input,
          timestamp: NewTransfer.parseDate(@input.date).toISOString()

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseErrors jqxhr.responseJSON
            @render()

      else
        @render()

    getInput: ->
      fromAccountGuid: @$('select[name="fromAccountGuid"]').val()
      toAccountGuid: @$('select[name="toAccountGuid"]').val()
      amount: @$('input[name="amount"]').val()
      date: @$('input[name="date"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.amount)
        errors.amount = 'Amount is required.'

      if Check.isMissing(input.date)
        errors.date = 'Date is required.'
      else if !NewTransfer.parseDate(input.date).isValid()
        errors.date = 'Date is invalid. Try something like \'3/15/16\' or \'10-31-17\''

      errors

    parseResponseErrors: (errors) ->
      errors = {}
      errors

    close: (e) ->
      e?.preventDefault()
      @trigger 'close'

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
