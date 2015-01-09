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

    render: ->
      @$el.html Index.template
        notes: @collection.toJSON()

      @

    events:
      'click ol.notes > li': 'showNote'

    showNote: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      @router.showNote @collection.get(guid)
