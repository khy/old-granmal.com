define [
  'backbone'
  'lib/view-el'
  'views/sign-in'
  'views/sign-up'
], (Backbone, ViewEl, SignIn, SignUp) ->

  class Auth extends Backbone.View

    className: 'auth'

    initialize: (opts) ->
      @session = opts.session
      @viewEl = new ViewEl @$el

      @signIn = new SignIn session: @session
      @listenTo @signIn, 'showSignUp', @showSignUp
      @listenTo @signIn, 'close', @close

      @signUp = new SignUp session: @session
      @listenTo @signUp, 'showSignIn', @showSignIn
      @listenTo @signUp, 'close', @close

    render: (view = @signIn) ->
      @viewEl.replace view
      @

    showSignIn: -> @render @signIn

    showSignUp: -> @render @signUp

    close: -> @trigger 'close'

    remove: ->
      @viewEl.clear()
      super
