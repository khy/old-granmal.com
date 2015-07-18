define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'text!haikunst/templates/index.hbs'
  'haikunst/collections/haikus'
  'haikunst/views/new-haiku'
], ($, _, Backbone, Handlebars, ElManager, template, Haikus, NewHaiku) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager

      @collection = new Haikus opts.haikus

      @listenTo @collection, 'change', @render

      @router = opts.router
      @session = opts.session

    render: ->
      @$el.html Index.template
        haikus: @collection.toJSON()

      @

    events:
      'click a.new-haiku': 'newHaiku'

    newHaiku: (e) ->
      e?.preventDefault()
      newHaiku = new NewHaiku
        session: @session

      closeNewNote = =>
        @setView @
        @router.navigate("")

      @listenTo newHaiku, 'close', closeNewNote

      @listenTo newHaiku, 'create', (haiku) ->
        @collection.unshift haiku
        closeNewNote()

      @setView newHaiku
      @router.navigate("haikus/new")
