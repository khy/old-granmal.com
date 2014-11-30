define [
  'jquery'
  'backbone'
  'handlebars'
  'models/book'
  'views/author-selector'
], ($, Backbone, Handlebars, Book, AuthorSelector) ->

  class NewBook extends Backbone.View

    @template: Handlebars.compile($("#new-book-template").html())

    initialize: (opts) ->
      @book = new Book
      @listenTo @book, 'invalid', @render

      @authorSelector = new AuthorSelector()
      @listenTo @authorSelector, 'select', @setAuthor

    render: (title) ->
      @$el.html NewBook.template
        title: title or @title
        titleError: if @book.validationError?.title == 'missing'
          'Title is required.'
        authorName: @selectedAuthor?.get('name')
        authorError: if @book.validationError?.author_guid == 'missing'
          'Author is required.'

      @

    events:
      'blur input[name="title"]': 'setTitle'
      'focus input[name="author_name"]': 'showAuthorSelector'
      'submit form': 'createBook'

    showAuthorSelector: ->
      @authorSelector.delegateEvents()
      @$el.html @authorSelector.render().el

      # Focusing on the query input won't work until the element is visible,
      # and I can't think of a way to handle that within AuthorSelector.
      @authorSelector.focusQueryInput()

    setTitle: ->
      # Save title outside of model so that input value does not get wiped out
      # on the re-render that is triggered by validation failure.
      @title = @$('input[name="title"]').val()

    createBook: (e) ->
      e.preventDefault()
      @setTitle()

      @book.save
        title: @title
        author_guid: @selectedAuthor?.get('guid')

    setAuthor: (author) ->
      @selectedAuthor = author
      @authorSelector.undelegateEvents()
      @render()

    remove: ->
      @authorSelector.remove()
      super
