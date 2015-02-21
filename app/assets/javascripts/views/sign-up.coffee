define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/validation/check'
  'lib/javascripts/form'
  'routers/server'
  'text!templates/sign-up.hbs'
], ($, _, Backbone, Handlebars, Check, Form, ServerRouter, template) ->

  Form.registerHelpers Handlebars

  class SignUp extends Backbone.View

    @template: Handlebars.compile template

    className: 'sign-up'

    initialize: (opts) ->
      @session = opts.session
      @router = opts.router

    navigate: -> @router.navigate 'sign-up'

    render: ->
      context = Form.buildFields @input, @errors
      @$el.html SignUp.template context
      @

    events:
      'submit form': 'signUp'
      'click a.sign-in': 'showSignIn'
      'click a.close': 'close'

    signUp: (e) ->
      e.preventDefault()
      @bind()

      if _.every(@errors, (errors) -> _.isEmpty errors)
        jqxhr = $.ajax _.extend ServerRouter.signUp, data: @input

        jqxhr.done (account) =>
          @session.create account
          @trigger 'close'
      else
        @render()

    showSignIn: (e) ->
      e.preventDefault()
      @trigger 'showSignIn'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'

    bind: ->
      @input = @getInput()
      @errors = @validate(@input)

    getInput: ->
      email: @$('input[name="email"]').val()
      password: @$('input[name="password"]').val()
      handle: @$('input[name="handle"]').val()
      name: @$('input[name="name"]').val()

    validate: (input) ->
      errors = email: [], password: [], handle: []

      if Check.isMissing(input.email)
        errors.email.push 'Email is required.'

      if Check.isMissing(input.password)
        errors.password.push 'Password is required.'

      if Check.isMissing(input.handle)
        errors.handle.push 'Username is required.'

      errors
