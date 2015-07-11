define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'text!haikunst/templates/haiku-form.hbs'
], ($, _, Backbone, Handlebars, template) ->

  class HaikuForm extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->

    render: ->
      @$el.html HaikuForm.template @opts
      @
