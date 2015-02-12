define [
  'jquery'
  'backbone'
  'handlebars'
  'text!templates/menu.hbs'
  'views/sign-in'
], ($, Backbone, Handlebars, template, SignIn) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @app = opts.app

      @listenTo @app.session, 'all', @render
      @listenTo @app.signInForm, 'close', @closeSignIn

    render: ->
      @$el.html Menu.template account: @app.session.account
      @

    events:
      'click a.sign-in': 'showSignIn'
      'click a.sign-out': 'signOut'
      'click a.close': 'close'

    showSignIn: (e) ->
      e.preventDefault()
      @app.mainEl.replace @app.signInForm

    closeSignIn: ->
      @app.mainEl.replace @

    signOut: (e) ->
      e.preventDefault()
      jqxhr = $.ajax type: 'DELETE', url: '/session'
      jqxhr.done =>
        @app.session.destroy()
        @trigger 'close'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
