define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/account'
  'text!budget/templates/new-account.hbs'
], ($, Backbone, Handlebars, ElManager, Check, Account, template) ->

  class NewAccount extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager
      @input = {}
      @account = new Account

      @listenTo @account, 'sync', ->
        @trigger 'create', @account

    render: ->
      @$el.html NewAccount.template _.extend @input,
        errors: @errors
        inputOptions: _.map Account.AccountTypes, (key, name) =>
          key: key, name: name, selected: @input.accountType == key
      @

    events:
      'submit form': 'create'
      'click a.close': 'close'

    create: (e) ->
      e?.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        jqxhr = @account.save @input

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseErrors jqxhr.responseJSON
            @render()

      else
        @render()

    getInput: ->
      accountType: @$('select[name="accountType"]').val()
      name: @$('input[name="name"]').val()
      initialBalance: @$('input[name="initialBalance"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.name)
        errors.name = 'Name is required.'

      if Check.isMissing(input.initialBalance)
        errors.initialBalance = 'Initial balance is required.'
      else if !Check.isNumeric(input.initialBalance)
        errors.initialBalance = 'Initial balance must be numeric.'
      else if input.accountType == Account.AccountTypes.Credit and
          Check.isPositive(input.initialBalance)
        errors.initialBalance = 'Initial balance must be less than or equal to 0 for credit accounts.'
      else if _.contains([Account.AccountTypes.Checking, Account.AccountTypes.Savings], input.accountType) and
          Check.isNegative(input.initialBalance)
        errors.initialBalance = "Initial balance must be greater than or equal to 0 for #{input.accountType} accounts."

      errors

    parseResponseError: (errors) ->
      errors = {}
      errors

    close: (e) ->
      e?.preventDefault()
      @trigger 'close'
