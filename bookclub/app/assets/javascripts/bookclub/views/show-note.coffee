define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'moment'
  'models/note'
], ($, _, Backbone, Handlebars, Moment, Note) ->

  class ShowNote extends Backbone.View

    @template: Handlebars.compile($("#show-note-template").html())

    initialize: (opts) ->
      @guid = opts.guid

      @model = opts.note || new Note guid: @guid
      @listenTo @model, 'change', @render

      @model.fetch() if !opts.note

    events:
      'click a.close': 'close'

    render: ->
      createdAt = Moment(@model.get("created_at"), Moment.ISO_8601).format("LLL")

      @$el.html ShowNote.template
        note: _.extend @model.toJSON(), created_at: createdAt

      @

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
