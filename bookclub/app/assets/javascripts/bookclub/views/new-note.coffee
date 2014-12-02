define [
  'jquery'
  'backbone'
  'handlebars'
  'views/book-selector'
], ($, Backbone, Handlebars, BookSelector) ->

  class NewNote extends Backbone.View

    @template: Handlebars.compile($("#new-note-template").html())

    initialize: (options) ->
      @note = new Note
      @listenTo @note, 'invalid', @render
      @listenTo @note, 'sync', @setNote

      @bookSelector = new BookSelector()
      @listenTo @bookSelector, 'select', @setBook

    render: ->
      @$el.html NewNote.template
        bookTitle: @selectedBook?.get('title')

    events:
      'focus input[name="book_title"]': 'showBookSelector'
      'submit form': 'createNote'

    createNote: ->
      e.preventDefault()

      @book.save
        book_guid: @selectedBook?.get('guid')
        page_number: @$('input[name="page_number"]').val()
        page_count: @$('input[name="page_count"]').val()
        content: @$('input[name="content"]').val()

    showBookSelector: ->
      @undelegateEvents()
      @bookSelector.delegateEvents()
      @$el.html @bookSelector.render().el
      @bookSelector.focusQueryInput()

    setBook: (book) ->
      @selectedBook = book
      @bookSelector.undelegateEvents()
      @delegateEvents()
      @render()
