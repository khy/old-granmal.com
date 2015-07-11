define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'text!haikunst/templates/index.hbs'
  'haikunst/views/new-haiku'
], ($, _, Backbone, Handlebars, ElManager, template, NewHaiku) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @opts = opts
      @router = opts.router

    render: ->
      @$el.html Index.template @opts

      @

    events:
      'click a.new-haiku': 'newHaiku'

    newHaiku: (e) ->
      e.preventDefault()
      newHaiku = new NewHaiku

      @listenTo newHaiku, 'close', ->
        @setView @
        @router.navigate("")

      @setView newHaiku
      @router.navigate("haikus/new")
