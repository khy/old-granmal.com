define [
  'jquery'
  'backbone'
  'handlebars'
  'views/show-note'
], ($, Backbone, Handlebars, ShowNote) ->

  class Index extends Backbone.View

    @template: Handlebars.compile($("#index-template").html())

    initialize: (opts) ->
      @app = opts.app

    render: ->
      @$el.html Index.template
        notes: @collection.toJSON()

      @

    events:
      'click ol.notes > li': 'showNote'
      'click a.new-note': 'newNote'

    showNote: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      @app.router.showNote @collection.get(guid)

    newNote: (e) ->
      e.preventDefault()
      view = @app.newNoteView()
      @listenTo view, 'close', @closeNewNote
      @app.mainEl.replace view

    closeNewNote: ->
      @app.mainEl.replace @, hard: true
