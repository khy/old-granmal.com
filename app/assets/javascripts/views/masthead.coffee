define [
  'backbone'
  'handlebars'
  'views/apps'
  'text!templates/masthead.hbs'
], (Backbone, Handlebars, Apps, template) ->

  class Masthead extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      @app = opts.app
      @apps = new Apps

    render: ->
      @$el.html Masthead.template
      @el.ontouchmove = (e) -> e.preventDefault()
      @

    afterInsert: (el) ->
      @$('.masthead .poster').height el.height() - 40

    events:
      'click': 'showApps'

    showApps: (e) ->
      e.preventDefault()
      @app.mainEl.replace @apps
