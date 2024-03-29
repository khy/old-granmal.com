define [
  'underscore'
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/auth/sign-in'
  'lib/javascripts/auth/sign-up'
], (_, Backbone, ElManager, SignIn, SignUp) ->

  class Auth extends Backbone.View

    initialize: (opts) ->
      _.extend @, ElManager

      @signIn = new SignIn opts
      @listenTo @signIn, 'showSignUp', ->
        @view = @signUp
        @render()
      @listenTo @signIn, 'close', -> @trigger 'close'

      @signUp = new SignUp opts
      @listenTo @signUp, 'showSignIn', ->
        @view = @signIn
        @render()
      @listenTo @signUp, 'close', -> @trigger 'close'

      @view = @signIn

    render: ->
      @setView @view
      @view.navigate()
      @

    delegateEvents: ->
      @view.delegateEvents()
      @

    undelegateEvents: ->
      @view.undelegateEvents()
      @
