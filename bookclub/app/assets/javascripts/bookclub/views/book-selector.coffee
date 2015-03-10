define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'bookclub/collections/books'
  'bookclub/views/new-book'
  'text!bookclub/templates/book-selector.hbs'
], ($, _, Backbone, Handlebars, Books, NewBook, template) ->

  class BookSelector extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      @books = new Books
      @listenTo @books, 'reset', @render

      @app = opts.app

      @newBook = new NewBook app: @app
      @listenTo @newBook, 'create', @selectNewBook
      @listenTo @newBook, 'close', @closeNewBook

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
      'click a.close': 'close'

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
      @newBook.setTitle(title)
      @app.mainEl.replace @newBook

    closeNewBook: ->
      @app.mainEl.replace @

    remove: ->
      @newBook.remove()
      super

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
