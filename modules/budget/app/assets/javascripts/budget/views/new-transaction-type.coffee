define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/transaction-type'
  'text!budget/templates/new-transaction-type.hbs'
], ($, Backbone, Handlebars, ElManager, Check, TransactionType, template) ->

  class NewTransactionType extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager
      @input = {}
      @transactionType = new TransactionType
      @transactionTypes = opts.transactionTypes

      @listenTo @transactionType, 'sync', ->
        @trigger 'create', @transactionType

    render: ->
      @$el.html NewTransactionType.template _.extend @input,
        parentOptions: @transactionTypes.map (transactionType) =>
          _.extend transactionType.toJSON(),
            selected: transactionType.get('guid') == @input.parentGuid
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
        jqxhr = @transactionType.save @input

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseErrors jqxhr.responseJSON
            @render()

      else
        @render()

    getInput: ->
      parentGuid: @$('select[name="parentGuid"]').val()
      name: @$('input[name="name"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.name)
        errors.name = 'Name is required.'

      errors

    parseResponseError: (errors) ->
      errors = {}
      errors

    close: (e) ->
      e?.preventDefault()
      @trigger 'close'
