define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/validation/check'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/auth/form'
  'lib/javascripts/alert'
  'bookclub/routers/server'
  'bookclub/models/note'
  'bookclub/models/book'
  'bookclub/views/book-selector'
  'bookclub/views/show-note'
  'text!bookclub/templates/new-note.hbs'
], ($, Backbone, Handlebars, Check, ElManager, AuthForm, Alert, ServerRouter,
    Note, Book, BookSelector, ShowNote, template) ->

  class NewNote extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager

      @note = new Note
      @listenTo @note, 'sync', ->
        @trigger 'create', @note

      @router = opts.router

      @session = opts.session
      @listenTo @session, 'create', ->
        Alert.success 'Signed in'
        @setView @

      @lastNoteCreated = opts.lastNoteCreated

      if bookAttributes = @lastNoteCreated?.get("book")
        @selectedBook = new Book bookAttributes

      @bookSelector = new BookSelector
      @listenTo @bookSelector, 'select', @setBook
      @listenTo @bookSelector, 'close', @closeBookSelector

    render: ->
      if @session.isSignedIn()
        @$el.html NewNote.template
          bookTitle: @selectedBook?.get('title')
          pageNumber: @input?.page_number
          pageTotal: @input?.page_total or @lastNoteCreated?.get("edition").page_count
          content: @input?.content
          errors: @errors
      else
        @showAuth()

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

    showAuth: ->
      authForm = new AuthForm
        session: @session
        formError: "You must sign-in to add a note."

      @listenTo authForm, 'close', ->
        @trigger 'close'

      @setView authForm

    showBookSelector: ->
      @setView @bookSelector
      @bookSelector.focusQueryInput()

    closeBookSelector: ->
      @setView @

    setBook: (book) ->
      @selectedBook = book
      @setView @

    remove: ->
      @bookSelector.remove()
      super

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
