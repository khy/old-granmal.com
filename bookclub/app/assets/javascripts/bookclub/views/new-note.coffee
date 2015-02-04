define [
  'jquery'
  'backbone'
  'handlebars'
  'bookclub/models/note'
  'bookclub/models/book'
  'bookclub/views/book-selector'
  'bookclub/utils/validation/check'
], ($, Backbone, Handlebars, Note, Book, BookSelector, Check) ->

  class NewNote extends Backbone.View

    @template: Handlebars.compile($("#new-note-template").html())

    initialize: (opts = {}) ->
      @note = new Note
      @listenTo @note, 'sync', @showNote

      @app = opts.app

      if bookAttributes = @app.lastNote?.get("book")
        @selectedBook = new Book(bookAttributes)

      @bookSelector = new BookSelector app: @app
      @listenTo @bookSelector, 'select', @setBook
      @listenTo @bookSelector, 'close', @closeBookSelector

    render: ->
      @$el.html NewNote.template
        bookTitle: @selectedBook?.get('title')
        pageNumber: @input?.page_number
        pageTotal: @input?.page_total or @app.lastNote?.get("edition").page_count
        content: @input?.content
        errors: @errors

    events:
      'focus input[name="book_title"]': 'showBookSelector'
      'submit form': 'createNote'
      'click a.close': 'close'

    createNote: (e) ->
      e.preventDefault()
      @input = @getInput()
      @errors = @validate(@input)

      if _.isEmpty(@errors)
        @note.save _.extend @input,
          page_number: parseInt(@input.page_number)
          page_total: parseInt(@input.page_total)
      else
        @render()

    showNote: -> @app.router.showNote @note

    getInput: ->
      book_guid: @selectedBook?.get('guid')
      page_number: @$('input[name="page_number"]').val()
      page_total: @$('input[name="page_total"]').val()
      content: @$('textarea[name="content"]').val()

    validate: (input) ->
      errors = {}

      if Check.isMissing(input.book_guid)
        errors.book = 'Book is required.'

      if Check.isMissing(input.page_number)
        errors.pages = 'Page is required.'
      else if !Check.isInteger(input.page_number)
        errors.pages ||= 'Page must be an integer.'
      else if !Check.isPositive(input.page_number)
        errors.pages ||= 'Page must be greater than zero.'

      if Check.isMissing(input.page_total)
        errors.pages ||= 'Total is required.'
      else if !Check.isInteger(input.page_total)
        errors.pages ||= 'Total must be an integer.'
      else if !Check.isPositive(input.page_total)
        errors.pages ||= 'Total must be greater than zero.'

      if Check.isGreaterThan(input.page_number, input.page_total)
        errors.pages ||= 'Page must be less than or equal to total.'

      if Check.isMissing(input.content)
        errors.content = 'Note is required.'

      errors

    showBookSelector: ->
      @app.mainEl.replace @bookSelector
      @bookSelector.focusQueryInput()

    setBook: (book) ->
      @selectedBook = book
      @app.mainEl.replace @

    closeBookSelector: ->
      @app.mainEl.replace @

    remove: ->
      @bookSelector.remove()
      super

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
