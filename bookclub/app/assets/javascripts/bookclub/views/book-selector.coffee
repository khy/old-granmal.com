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

    selectExistingBook: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      @selectBook(guid)

    selectBook: _.throttle (guid) ->
      console.log(guid)
      console.log(@books)
      selectedBook = @books.get(guid)
      @trigger 'select', selectedBook
    , 1000

    showNewBook: (e) ->
      e.preventDefault()
      title = @queryInput().val()
      @undelegateEvents()
      @newBook.delegateEvents()
      @$el.html @newBook.render(title).el
