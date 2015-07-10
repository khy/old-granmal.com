define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'text!haikunst/templates/index.hbs'
], ($, _, Backbone, Handlebars, template) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      @opts = opts

    render: ->
      @$el.html Index.template @opts

      @
