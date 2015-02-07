define [
  'backbone'
  'handlebars'
  'text!templates/apps.hbs'
], (Backbone, Handlebars, template) ->

  class Apps extends Backbone.View

    @template: Handlebars.compile(template)

    render: ->
      @$el.html Apps.template
      @
