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
      @$el.html SignUp.template
      @

    events:
      'submit form': 'signUp'
      'click a.sign-in': 'showSignIn'
      'click a.close': 'close'

    signUp: (e) ->
      e.preventDefault()

      jqxhr = $.ajax _.extend ServerRouter.signUp,
        data:
          email: @$('#email').val()
          password: @$('#password').val()
          handle: @$('#handle').val()
          name: @$('#name').val()

      jqxhr.done (account) =>
        @session.create account
        @trigger 'close'

    showSignIn: (e) ->
      e.preventDefault()
      @trigger 'showSignIn'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
