define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'lib/javascripts/auth/session'
  'lib/javascripts/auth/form'
  'budget/views/index'
], (Backbone, ElManager, Prestitial, Session, AuthForm, Index) ->

  class ClientRouter extends Backbone.Router

    initialize: (opts) ->
      @el = $("#main")
      _.extend @, ElManager

      @showPrestitial = true

      @session = new Session opts.account

      @index = new Index
        router: @,
        session: @session,
        accounts: opts.accounts

    routes:
      '': 'index'
      'accounts/new': 'newAccount'

    index: ->
      @_render =>
        @setView @index

    newAccount: ->
      @_render =>
        @setView @index
        @index.newAccount()

    _render: (render) ->
      if @showPrestitial
        prestitial = new Prestitial el: @el
        @listenTo prestitial, 'continue', ->
          @showPrestitial = false
          @_render render
        @setView prestitial
      else if !@session.isSignedIn()
        authForm = new AuthForm
          session: @session
          formError: "You must sign-in or sign-up to use Budget."

        @listenTo authForm, 'close', -> @_render render
        @listenToOnce @session, 'create', -> @_render render

        @setView authForm
      else
        render()
