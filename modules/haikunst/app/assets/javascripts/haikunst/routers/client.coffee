define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'haikunst/views/index'
], (Backbone, ElManager, Prestitial, Index) ->

  class ClientRouter extends Backbone.Router

    initialize: (bootstrap) ->
      @el = $("#main")
      _.extend @, ElManager

      @showPrestitial = bootstrap.showPrestitial || true

      @index = new Index bootstrap

    routes:
      '' : 'index'

    index: ->
      if @showPrestitial
        prestitial = new Prestitial el: @el
        @listenTo prestitial, 'continue', ->
          @showPrestitial = false
          @setView @index
        @setView prestitial
      else
        @setView @index
