define ['jquery', 'backbone', 'handlebars'], ($, Backbone, Handlebars) ->

  class NewBook extends Backbone.View

    template: Handlebars.compile($("#new-book-template").html())

    render: ->
      @$el.html @template()
