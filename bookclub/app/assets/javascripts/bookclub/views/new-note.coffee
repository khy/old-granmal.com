define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/validation/check'
  'lib/javascripts/el-manager'
  'bookclub/models/note'
  'bookclub/models/book'
  'bookclub/views/book-selector'
  'bookclub/views/show-note'
  'text!bookclub/templates/new-note.hbs'
], ($, Backbone, Handlebars, Check, ElManager, Note, Book, BookSelector, ShowNote, template) ->

  class NewNote extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager

      @note = new Note
      @listenTo @note, 'sync', @showNote

      @router = opts.router
      @lastNoteCreated = opts.lastNoteCreated

      if bookAttributes = @lastNoteCreated?.get("book")
        @selectedBook = new Book bookAttributes

      @bookSelector = new BookSelector
      @listenTo @bookSelector, 'select', @setBook
      @listenTo @bookSelector, 'close', @closeBookSelector

    render: ->
      @$el.html NewNote.template
        bookTitle: @selectedBook?.get('title')
        pageNumber: @input?.page_number
        pageTotal: @input?.page_total or @lastNoteCreated?.get("edition").page_count
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

    showNote: ->
      view = new ShowNote note: @note
      @listenTo view, 'close', =>
        @router.navigate "", trigger: true
      @setView view
      @router.navigate("notes/#{@note.id}")

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
      @setView @bookSelector
      @bookSelector.focusQueryInput()

    setBook: (book) ->
      @selectedBook = book
      @setView @

    closeBookSelector: ->
      @setView @

    remove: ->
      @bookSelector.remove()
      super

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
