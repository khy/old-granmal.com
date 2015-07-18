define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/alert'
  'lib/javascripts/auth/form'
  'lib/javascripts/validation/check'
  'text!haikunst/templates/new-haiku.hbs'
  'haikunst/models/haiku'
], ($, _, Backbone, Handlebars, ElManager, Alert, AuthForm, Check, template, Haiku) ->

  class HaikuForm extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager

      @haiku = new Haiku

      @session = opts.session
      @listenTo @session, 'create', ->
        Alert.success 'Signed in'
        @setView @

    render: ->
      if @session.isSignedIn()
        options = _.extend @input, errors: @errors
        @$el.html HaikuForm.template options
      else
        authForm = new AuthForm
          session: @session
          formError: "You must sign-in or sign-up to add a haiku."

        @listenTo authForm, 'close', ->
          @setView @

        @setView authForm

    events:
      'submit form': 'createHaiku'
      'click a.close': 'close'

    createHaiku: (e) ->
      e.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        jqxhr = @haiku.save @input

        jqxhr.fail (jqxhr) =>
          if jqxhr.status == 409
            @errors = @parseResponseError jqxhr.responseJSON
            @render(@input)

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

    parseResponseError: (data) ->
      errors = {}

      if _.isString data[0]
        errors.one = @getErrorDisplay data[0]

      if _.isString data[1]
        errors.two = @getErrorDisplay data[1]

      if _.isString data[2]
        errors.three = @getErrorDisplay data[2]

      errors

    getErrorDisplay: (key) ->
      switch key
        when 'useless.haiku.error.too_few_syllables' then 'Zu wenige Silben!'
        when 'useless.haiku.error.too_many_syllables' then 'Zu viele Silben!'
        else 'Fehler!'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
