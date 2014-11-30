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
        lastNote: @lastNote

    events:
      'focus input[name="book_name"]': 'showBookSelector'

    showBookSelector: ->
      @bookSelector.delegateEvents()
      @$el.html @bookSelector.render().el
      @bookSelector.focusQueryInput()

    setBook: (book) ->
      console.log(book)
