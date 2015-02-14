define [
  'jquery'
  'backbone'
  'handlebars'
  'routers/server'
  'text!templates/sign-up.hbs'
], ($, Backbone, Handlebars, ServerRouter, template) ->

  class SignUp extends Backbone.View

    @template: Handlebars.compile template

    className: 'sign-up'

    initialize: (opts) ->
      @session = opts.session
      @router = opts.router

    navigate: -> @router.navigate 'sign-up'

    render: ->
      @$el.html SignUp.template _.extend @input, errors: @errors
      @

    events:
      'submit form': 'signUp'
      'click a.sign-in': 'showSignIn'
      'click a.close': 'close'

    signUp: (e) ->
      e.preventDefault()
      @bind()

      if _.isEmpty(@errors)
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
      errors = {}

      if Check.isMissing(input.email)
        errors.email = 'Email is required.'

      if Check.isMissing(input.password)
        errors.password = 'Password is required.'

      if Check.isMissing(input.handle)
        errors.handle = 'Username is required.'

      errors
