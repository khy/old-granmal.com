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
      @haikuForm = new HaikuForm

    render: ->
      @$el.html Index.template @opts

      @

    events:
      'click a.new-haiku': 'newHaiku'

    newHaiku: (e) ->
      e.preventDefault()
      @setView @haikuForm
