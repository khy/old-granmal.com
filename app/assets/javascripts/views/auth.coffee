define [
  'backbone'
  'views/sign-in'
  'views/sign-up'
], (Backbone, SignIn, SignUp) ->

  class Auth extends Backbone.View

    initialize: (opts) ->
      @session = opts.session

      @signIn = new SignIn session: @session
      @listenTo @signIn, 'showSignUp', @showSignUp
      @listenTo @signIn, 'close', @close

      @signUp = new SignUp session: @session
      @listenTo @signUp, 'showSignIn', @showSignIn
      @listenTo @signUp, 'close', @close

    render: (view = @signIn) ->
      view.render()
      @$el.html view.el
      @

    showSignIn: -> @render @signIn

    showSignUp: -> @render @signUp

    close: -> @trigger 'close'

    delegateEvents: ->
      @signIn.delegateEvents()
      @signUp.delegateEvents()
      super

    remove: ->
      @signIn.remove()
      @signUp.remove()
      super
