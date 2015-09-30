define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'text!budget/templates/index.hbs'
], (
  $, _, Backbone, Handlebars, ElManager, template
) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @app = opts.app

    render: ->
      @$el.html Index.template
      @

    events:
      'click a.plan': 'plan'
      'click a.resolve': 'resolve'

    plan: (e) ->
      e?.preventDefault()
      @app.navigate 'plan', trigger: true

    resolve: (e) ->
      e?.preventDefault()
      @app.navigate 'resolve', trigger: true
