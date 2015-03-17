define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/el-manager'
  'bookclub/models/book'
  'bookclub/views/author-selector'
  'text!bookclub/templates/new-book.hbs'
], ($, Backbone, Handlebars, ElManager, Book, AuthorSelector, template) ->

  class NewBook extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager

      @book = new Book
      @listenTo @book, 'invalid', @render
      @listenTo @book, 'sync', @setBook

      @authorSelector = new AuthorSelector
      @listenTo @authorSelector, 'select', @setAuthor
      @listenTo @authorSelector, 'close', @closeAuthorSelector

    render: (title) ->
      @$el.html NewBook.template
        title: @title
        titleError: if @book.validationError?.title == 'missing'
          'Title is required.'
        authorName: @selectedAuthor?.get('name')
        authorError: if @book.validationError?.author_guid == 'missing'
          'Author is required.'

      @

    events:
      'blur input[name="title"]': 'saveTitle'
      'focus input[name="author_name"]': 'showAuthorSelector'
      'submit form': 'createBook'
      'click a.close': 'close'

    setTitle: (title) ->
      @title = title

    showAuthorSelector: ->
      @setView @authorSelector
      @authorSelector.focusQueryInput()

    setAuthor: (author) ->
      @selectedAuthor = author
      @setView @

    closeAuthorSelector: ->
      @setView @

    saveTitle: ->
      # Save title outside of model so that input value does not get wiped out
      # on the re-render that is triggered by validation failure.
      @title = @$('input[name="title"]').val()

    createBook: (e) ->
      e.preventDefault()
      @saveTitle()

      @book.save
        title: @title
        author_guid: @selectedAuthor?.get('guid')

    setBook: _.throttle (book) ->
      @trigger 'create', book
    , 1000

    remove: ->
      @authorSelector.remove()
      super

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
