define [
  'backbone'
  'handlebars'
  'text!templates/sign-in.hbs'
], (Backbone, Handlebars, template) ->

  class SignIn extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @app = opts.app

    render: ->
      @$el.html SignIn.template
      @

    events:
      'submit form': 'signIn'
      'click a.close': 'close'

    signIn: (e) ->
      e.preventDefault()

      opts =
        email: @$("#email").val()
        password: @$("#password").val()

      console.log opts

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
