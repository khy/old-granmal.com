define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'haikunst/views/index'
  'haikunst/views/new-haiku'
], (Backbone, ElManager, Prestitial, Index, NewHaiku) ->

  class ClientRouter extends Backbone.Router

    initialize: (bootstrap) ->
      @el = $("#app")
      _.extend @, ElManager

      @showPrestitial = bootstrap.showPrestitial || true

      @index = new Index _.extend bootstrap, router: @

    routes:
      '' : 'index'
      'haikus/new': 'newHaiku'

    index: ->
      @_showViewOrPrestitial @index

    newHaiku: ->
      newHaiku = new NewHaiku
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
