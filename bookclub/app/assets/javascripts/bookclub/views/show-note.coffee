define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'moment'
  'bookclub/models/note'
  'text!bookclub/templates/show-note.hbs'
], ($, _, Backbone, Handlebars, Moment, Note, template) ->

  class ShowNote extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      @model = opts.note || new Note guid: opts.guid
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
