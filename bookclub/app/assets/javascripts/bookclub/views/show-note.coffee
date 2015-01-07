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

      @note = opts.note || new Note guid: @guid
      @listenTo @note, 'change', @render

      @note.fetch() if !opts.note

    render: ->
      @$el.html ShowNote.template
        note: @note.toJSON()

      @
