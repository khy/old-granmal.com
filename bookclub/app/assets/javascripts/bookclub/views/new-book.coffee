define [
  'jquery'
  'backbone'
  'handlebars'
  'views/author-selector'
], ($, Backbone, Handlebars, AuthorSelector) ->

  class NewBook extends Backbone.View

    template: Handlebars.compile($("#new-book-template").html())

    render: ->
      @$el.html @template()

    events:
      'click input[name="author_name"]': 'showAuthorSelector'

    showAuthorSelector: ->
      @$el.html @_authorSelector.render().el

    _authorSelector: new AuthorSelector()
