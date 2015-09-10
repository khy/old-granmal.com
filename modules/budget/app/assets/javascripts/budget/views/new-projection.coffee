define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/validation/check'
  'budget/models/projection'
  'text!budget/templates/new-projection.hbs'
], ($, Backbone, Handlebars, ElManager, Check, Projection, template) ->

  class NewProjection extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager
      @input = {}
      @projection = new Projection

      @listenTo @projection, 'sync', ->
        @trigger 'create', @projection

    render: ->
      @$el.html NewProjection.template _.extend @input, errors: @errors
      @

    events:
      'submit form': 'create'
      'click a.close': 'close'

    create: (e) ->
      e?.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        jqxhr = @projection.save @input

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseErrors jqxhr.responseJSON
            @render()

      else
        @render()

    getInput: ->
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
