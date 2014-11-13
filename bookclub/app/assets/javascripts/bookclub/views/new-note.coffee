define ['jquery', 'backbone', 'handlebars'], ($, Backbone, Handlebars) ->

  class NewNote extends Backbone.View

    initialize: (options) ->
      @lastNote = options.lastNote

    template: Handlebars.compile($("#new-note-template").html())

    render: ->
      @$el.html @template
        lastNote: @lastNote
