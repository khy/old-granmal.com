define [
  'jquery'
  'backbone'
  'handlebars'
  'views/show-note'
], ($, Backbone, Handlebars, ShowNote) ->

  class Index extends Backbone.View

    @template: Handlebars.compile($("#index-template").html())

    initialize: (opts) ->
      @router = opts.router
      @mainEl = opts.mainEl

    render: ->
      @$el.html Index.template
        notes: @collection.toJSON()

      @

    events:
      'click ol.notes > li': 'showNote'

    showNote: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      note = @collection.get(guid)
      view = new ShowNote note: note
      @mainEl.insertView view
      @router.navigate("notes/#{guid}")
