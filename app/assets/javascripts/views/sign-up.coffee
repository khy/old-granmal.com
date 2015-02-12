define [
  'jquery'
  'backbone'
  'handlebars'
  'text!templates/sign-up.hbs'
], ($, Backbone, Handlebars, template) ->

  class SignUp extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @session = opts.session

    render: ->
      @$el.html SignUp.template
      @

    events:
      'submit form': 'signUp'
      'click a.sign-in': 'showSignIn'
      'click a.close': 'close'

    signUp: (e) ->
      e.preventDefault()

      jqxhr = $.post '/sign-up',
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
