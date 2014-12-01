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
      @listenTo @book, 'sync', @setBook

      @authorSelector = new AuthorSelector()
      @listenTo @authorSelector, 'select', @setAuthor

    render: (title) ->
      @title ||= title

      @$el.html NewBook.template
        title: @title
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
      @undelegateEvents()
      @authorSelector.delegateEvents()
      @$el.html @authorSelector.render().el
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

    setBook: _.throttle (book) ->
      @trigger 'create', book
    , 1000

    setAuthor: (author) ->
      @selectedAuthor = author
      @delegateEvents()
      @authorSelector.undelegateEvents()
      @render()

    remove: ->
      @authorSelector.remove()
      super
