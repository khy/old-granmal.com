define [
  'jquery'
  'backbone'
  'handlebars'
], ($, Backbone, Handlebars, Router) ->

  class Index extends Backbone.View

    @template: Handlebars.compile($("#index-template").html())

    initialize: (opts) ->
      @notes = opts.initialNotes
      @router = opts.router

    render: ->
      @$el.html Index.template
        notes: @notes.toJSON()

      @

    events:
      'click ol.notes > li': 'showNote'

    showNote: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      @router.navigate "notes/#{guid}", trigger: true
