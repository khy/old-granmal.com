define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/validation/check'
  'lib/javascripts/form'
  'text!lib/templates/auth/sign-in.hbs'
], ($, _, Backbone, Handlebars, Check, Form, template) ->

  Form.registerHelpers Handlebars

  class SignIn extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @session = opts.session
      @clientRouter = opts.clientRouter
      @formError = opts.formError

      @input = {}
      @fieldErrors = {}

    navigate: -> @clientRouter?.navigate 'sign-in'

    render: ->
      @$el.html SignIn.template
        formError: @formError
        fields: Form.buildFields @input, @fieldErrors
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
        jqxhr = $.ajax url: '/sessions', method: 'POST', data: @input

        jqxhr.done (account) =>
          @session.create account

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
