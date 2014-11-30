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
      'click a.new-book': 'showNewBook'

    search: _.debounce ->
      query = @queryInput().val()

      if query.length > 0
        @books.fetch
          data: title: query
          reset: true
    , 300

    showNewBook: (e) ->
      e.preventDefault()
      title = @queryInput().val()
      @newBook.delegateEvents()
      @$el.html @newBook.render(title).el
