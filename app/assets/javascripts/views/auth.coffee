define [
  'backbone'
  'lib/view-el'
  'views/sign-in'
  'views/sign-up'
], (Backbone, ViewEl, SignIn, SignUp) ->

  class Auth extends Backbone.View

    className: 'auth'

    initialize: (opts) ->
      @viewEl = new ViewEl @$el

      @signIn = new SignIn opts
      @listenTo @signIn, 'showSignUp', ->
        @setView @signUp
        @render()
      @listenTo @signIn, 'close', -> @trigger 'close'

      @signUp = new SignUp opts
      @listenTo @signUp, 'showSignIn', ->
        @setView @signIn
        @render()
      @listenTo @signUp, 'close', -> @trigger 'close'

      @setView @signIn

    render: ->
      @viewEl.replace @view
      @view.navigate()
      @

    setView: (view) ->
      @view = view

    remove: ->
      @viewEl.clear()
      super
