define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'lib/javascripts/auth/session'
  'haikunst/views/index'
  'haikunst/views/new-haiku'
], (Backbone, ElManager, Prestitial, Session, Index, NewHaiku) ->

  class ClientRouter extends Backbone.Router

    initialize: (bootstrap) ->
      @el = $("#app")
      _.extend @, ElManager

      @showPrestitial = bootstrap.showPrestitial || true

      @session = new Session bootstrap.account

      @index = new Index
        haikus: bootstrap.haikus
        router: @,
        session: @session

    routes:
      '' : 'index'
      'haikus/new': 'newHaiku'

    index: ->
      @_showViewOrPrestitial @index

    newHaiku: ->
      newHaiku = new NewHaiku
        session: @session
      @_showViewOrPrestitial newHaiku

    _showViewOrPrestitial: (view) ->
      if @showPrestitial
        prestitial = new Prestitial el: @el
        @listenTo prestitial, 'continue', ->
          @showPrestitial = false
          @setView view
        @setView prestitial
      else
        @setView view
