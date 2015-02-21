define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/validation/check'
  'lib/javascripts/form/field'
  'routers/server'
  'text!templates/sign-in.hbs'
], ($, _, Backbone, Handlebars, Check, Field, ServerRouter, template) ->

  Field.registerHelpers Handlebars

  class SignIn extends Backbone.View

    @template: Handlebars.compile template

    className: 'sign-in'

    initialize: (opts) ->
      @session = opts.session
      @router = opts.router

      @input = {}
      @fieldErrors = {}

    navigate: -> @router.navigate 'sign-in'

    render: ->
      @$el.html SignIn.template
        formError: @formError
        fields: Field.buildData @input, @fieldErrors
      @

    events:
      'submit form': 'signIn'
      'click a.sign-up': 'showSignUp'
      'click a.close': 'close'

    signIn: (e) ->
      e.preventDefault()
      @input = @getInput()
      @fieldErrors = @validate(@input)

      if _.every(@fieldErrors, (errors) -> _.isEmpty errors)
        jqxhr = $.ajax _.extend ServerRouter.signIn, data: @input

        jqxhr.done (account) =>
          @session.create account
          @trigger 'close'

        jqxhr.fail (jqxhr) =>
          @formError = jqxhr.responseText
          @render()

      else
        @render()

    getInput: ->
      email: @$('input[name="email"]').val()
      password: @$('input[name="password"]').val()

    validate: (input) ->
      fieldErrors = email: [], password: []

      if Check.isMissing(input.email)
        fieldErrors.email.push 'Email is required.'

      if Check.isMissing(input.password)
        fieldErrors.password.push 'Password is required.'

      fieldErrors

    showSignUp: (e) ->
      e.preventDefault()
      @trigger 'showSignUp'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
