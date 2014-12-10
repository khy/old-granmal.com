define [
  'jquery'
  'backbone'
  'handlebars'
], ($, Backbone, Handlebars) ->

  class Index extends Backbone.View

    @template: Handlebars.compile($("#index-template").html())

    initialize: (opts) ->
      @notes = opts.initialNotes

    render: ->
      @$el.html Index.template
        notes: @notes.toJSON()

      @
