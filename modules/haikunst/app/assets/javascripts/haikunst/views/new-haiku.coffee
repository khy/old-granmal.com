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
      @$el.html HaikuForm.template @opts
      @haiku = new Haiku

    events:
      'submit form': 'createHaiku'
      'click a.close': 'close'

    createHaiku: (e) ->
      e.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      console.log @errors

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

      if Check.isMissing(input.one) or Check.isMissing(input.two) or Check.isMissing(input.three)
        errors.global = 'All lines are required.'

      errors

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
