define [
  'backbone'
  'handlebars'
], (Backbone, Handlebars) ->

  class Apps extends Backbone.View

    @template: Handlebars.compile($("#apps-template").html())

    render: ->
      @$el.html Apps.template
      @
