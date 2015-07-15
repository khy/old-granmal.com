define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/validation/check'
  'text!haikunst/templates/new-haiku.hbs'
  'haikunst/models/haiku'
], ($, _, Backbone, Handlebars, Check, template, Haiku) ->

  class HaikuForm extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      @haiku = new Haiku

    render: ->
      options = _.extend @input, errors: @errors
      @$el.html HaikuForm.template options

    events:
      'submit form': 'createHaiku'
      'click a.close': 'close'

    createHaiku: (e) ->
      e.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        @haiku.save @input
      else
        @render()

    getInput: ->
      one: @$('input[name="one"]').val()
      two: @$('input[name="two"]').val()
      three: @$('input[name="three"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.one)
        errors.one = 'All lines are required.'

      if Check.isMissing(input.two)
        errors.two = 'All lines are required.'

      if Check.isMissing(input.three)
        errors.three = 'All lines are required.'

      errors

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
