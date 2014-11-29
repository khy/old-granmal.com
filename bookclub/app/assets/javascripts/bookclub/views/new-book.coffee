define [
  'jquery'
  'backbone'
  'handlebars'
  'views/author-selector'
], ($, Backbone, Handlebars, AuthorSelector) ->

  class NewBook extends Backbone.View

    @template: Handlebars.compile($("#new-book-template").html())

    initialize: ->
      @authorSelector = new AuthorSelector()
      @listenTo @authorSelector, 'select', @setAuthor

    render: ->
      @$el.html NewBook.template
        authorGuid: @selectedAuthor?.get("guid")
        authorName: @selectedAuthor?.get("name")

    events:
      'click input[name="author_name"]': 'showAuthorSelector'

    showAuthorSelector: ->
      @authorSelector.delegateEvents()
      @$el.html @authorSelector.render().el

    setAuthor: (author) ->
      @selectedAuthor = author
      @authorSelector.undelegateEvents()
      @render()

    remove: ->
      @authorSelector.remove()
      super
