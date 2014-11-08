define ['jquery', 'backbone', 'handlebars'], ($, Backbone, Handlebars) ->

  class NewNote extends Backbone.View

    tagName: "div"

    template: Handlebars.compile($("#new-note-template").html())

    render: ->
      @$el.html @template name: 'Kevin'
