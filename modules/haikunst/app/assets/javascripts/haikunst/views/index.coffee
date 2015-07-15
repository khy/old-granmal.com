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

      @haikus = opts.haikus
      @router = opts.router
      @session = opts.session

    render: ->
      @$el.html Index.template
        haikus: @haikus

      @

    events:
      'click a.new-haiku': 'newHaiku'

    newHaiku: (e) ->
      e.preventDefault()
      newHaiku = new NewHaiku
        session: @session

      @listenTo newHaiku, 'close', ->
        @setView @
        @router.navigate("")

      @setView newHaiku
      @router.navigate("haikus/new")
