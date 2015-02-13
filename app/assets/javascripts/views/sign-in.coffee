define [
  'jquery'
  'backbone'
  'handlebars'
  'text!templates/sign-in.hbs'
], ($, Backbone, Handlebars, template) ->

  class SignIn extends Backbone.View

    @template: Handlebars.compile template

    className: 'sign-in'

    initialize: (opts) ->
      @session = opts.session

    render: ->
      @$el.html SignIn.template
      @

    events:
      'submit form': 'signIn'
      'click a.sign-up': 'showSignUp'
      'click a.close': 'close'

    signIn: (e) ->
      e.preventDefault()

      jqxhr = $.post '/sign-in',
        email: @$("#email").val()
        password: @$("#password").val()

      jqxhr.done (account) =>
        @session.create account
        @trigger 'close'

    showSignUp: (e) ->
      e.preventDefault()
      @trigger 'showSignUp'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
