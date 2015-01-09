define [
  'jquery'
  'backbone'
  'handlebars'
  'models/note'
], ($, Backbone, Handlebars, Note) ->

  class ShowNote extends Backbone.View

    @template: Handlebars.compile($("#show-note-template").html())

    initialize: (opts) ->
      @guid = opts.guid

      @model = opts.note || new Note guid: @guid
      @listenTo @model, 'change', @render

      @model.fetch() if !opts.note

    render: ->
      @$el.html ShowNote.template
        note: @model.toJSON()

      @
