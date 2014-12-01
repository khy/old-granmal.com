define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'collections/books'
  'views/new-book'
], ($, _, Backbone, Handlebars, Books, NewBook) ->

  class BookSelector extends Backbone.View

    @template: Handlebars.compile($('#book-selector-template').html())

    initialize: ->
      @books = new Books
      @listenTo @books, 'reset', @render

      @newBook = new NewBook
      @listenTo @newBook, 'create', @selectNewBook

    queryInput: -> @$('input[name="query"]')

    render: ->
      @$el.html BookSelector.template
        query: @queryInput().val()
        books: @books.toJSON()

      @focusQueryInput()

      @

    focusQueryInput: ->
      queryInput = @queryInput()
      focusOffset = queryInput.val().length * 2
      queryInput.focus()
      queryInput[0].setSelectionRange(focusOffset, focusOffset)

    events:
      'keyup input[name="query"]': 'search'
      'click a.existing-book': 'selectExistingBook'
      'click a.new-book': 'showNewBook'

    search: _.debounce ->
      query = @queryInput().val()

      if query.length > 0
        @books.fetch
          data: title: query
          reset: true
    , 300

    selectNewBook: (book) ->
      @selectBook(book)

    selectExistingBook: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      selectedBook = @books.get(guid)
      @selectBook(selectedBook)

    selectBook: _.throttle (book) ->
      @trigger 'select', book
    , 1000

    showNewBook: (e) ->
      e.preventDefault()
      title = @queryInput().val()
      @undelegateEvents()
      @newBook.delegateEvents()
      @$el.html @newBook.render(title).el
