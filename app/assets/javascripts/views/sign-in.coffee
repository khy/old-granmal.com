define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/validation/check'
  'routers/server'
  'text!templates/sign-in.hbs'
], ($, _, Backbone, Handlebars, Check, ServerRouter, template) ->

  class SignIn extends Backbone.View

    @template: Handlebars.compile template

    className: 'sign-in'

    initialize: (opts) ->
      @session = opts.session
      @router = opts.router

    navigate: -> @router.navigate 'sign-in'

    render: ->
      input = _.extend @input, errors: @errors
      @$el.html SignIn.template input
      @

    events:
      'submit form': 'signIn'
      'click a.sign-up': 'showSignUp'
      'click a.close': 'close'

    signIn: (e) ->
      e.preventDefault()
      @bind()

      if _.isEmpty(@errors)
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
      errors = {}

      if Check.isMissing(input.email)
        errors.email = 'Email is required.'

      if Check.isMissing(input.password)
        errors.password = 'Password is required.'

      errors
