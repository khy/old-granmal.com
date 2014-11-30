define [
  'jquery'
  'backbone'
  'handlebars'
  'views/book-selector'
], ($, Backbone, Handlebars, BookSelector) ->

  class NewNote extends Backbone.View

    @template: Handlebars.compile($("#new-note-template").html())

    initialize: (options) ->
      @lastNote = options.lastNote

      @bookSelector = new BookSelector()
      @listenTo @bookSelector, 'select', @setBook

    render: ->
      @$el.html NewNote.template
        bookTitle: @selectedBook?.get('title')

    events:
      'focus input[name="book_title"]': 'showBookSelector'

    showBookSelector: ->
      @undelegateEvents()
      @bookSelector.delegateEvents()
      @$el.html @bookSelector.render().el
      @bookSelector.focusQueryInput()

    setBook: (book) ->
      console.log(book)
      @selectedBook = book
      @bookSelector.undelegateEvents()
      @delegateEvents()
      @render()
