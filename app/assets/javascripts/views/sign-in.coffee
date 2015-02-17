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
      @errors = {}

    navigate: -> @router.navigate 'sign-in'

    render: ->
      context = Field.buildData @input, @errors
      @$el.html SignIn.template context
      @

    events:
      'submit form': 'signIn'
      'click a.sign-up': 'showSignUp'
      'click a.close': 'close'

    signIn: (e) ->
      e.preventDefault()
      @bind()

      if _.every(@errors, (errors) -> _.isEmpty errors)
        jqxhr = $.ajax _.extend ServerRouter.signIn, data: @input

        jqxhr.done (account) =>
          @session.create account
          @trigger 'close'
      else
        @render()

    showSignUp: (e) ->
      e.preventDefault()
      @trigger 'showSignUp'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'

    bind: ->
      @input = @getInput()
      @errors = @validate(@input)

    getInput: ->
      email: @$('input[name="email"]').val()
      password: @$('input[name="password"]').val()

    validate: (input) ->
      errors = email: [], password: []

      if Check.isMissing(input.email)
        errors.email.push 'Email is required.'

      if Check.isMissing(input.password)
        errors.password.push 'Password is required.'

      errors
