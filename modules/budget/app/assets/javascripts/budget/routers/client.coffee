define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'budget/views/index'
], (Backbone, ElManager, Prestitial, Index) ->

  class ClientRouter extends Backbone.Router

    initialize: (config) ->
      @el = $("#main")
      _.extend @, ElManager

      @showPrestitial = true

      @index = new Index
        router: @,
        session: @session

    routes:
      '': 'index'
      'accounts/new': 'newAccount'

    index: ->
      @_showViewOrPrestitial =>
        @setView @index

    newAccount: ->
      @_showViewOrPrestitial =>
        @setView @index
        @index.newAccount()

    _showViewOrPrestitial: (render) ->
      if @showPrestitial
        prestitial = new Prestitial el: @el
        @listenTo prestitial, 'continue', ->
          @showPrestitial = false
          render()
        @setView prestitial
      else
        render()
