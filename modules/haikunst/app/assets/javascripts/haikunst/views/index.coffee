define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'text!haikunst/templates/index.hbs'
  'haikunst/views/haiku-form'
], ($, _, Backbone, Handlebars, ElManager, template, HaikuForm) ->

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
      haikuForm = new HaikuForm

      @listenTo haikuForm, 'close', ->
        @setView @
        @router.navigate("")

      @setView haikuForm
      @router.navigate("haikus/new")
