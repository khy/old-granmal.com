define [
  'backbone'
  'handlebars'
  'text!templates/menu.hbs'
  'views/sign-in'
], (Backbone, Handlebars, template, SignIn) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @app = opts.app

      @listenTo @app.signInForm, 'signIn', @closeSignIn
      @listenTo @app.signInForm, 'close', @closeSignIn

    render: ->
      @$el.html Menu.template account: @app.account
      @

    events:
      'click a.sign-in': 'showSignIn'
      'click a.close': 'close'

    showSignIn: (e) ->
      e.preventDefault()
      @app.mainEl.replace @app.signInForm

    closeSignIn: ->
      @app.mainEl.replace @

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
