define [
  'backbone'
  'handlebars'
], (Backbone, Handlebars) ->

  class Masthead extends Backbone.View

    @template: Handlebars.compile($("#masthead-template").html())

    render: ->
      @$el.html Masthead.template
      @
