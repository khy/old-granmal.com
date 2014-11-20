define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'collections/authors'
], ($, _, Backbone, Handlebars, Authors) ->

  class AuthorSelector extends Backbone.View

    @template: Handlebars.compile($('#author-selector-template').html())

    initialize: ->
      @authors = new Authors
      @listenTo @authors, "reset", @render

    queryInput: -> @$('input[name="query"]')

    render: ->
      @$el.html AuthorSelector.template
        query: @queryInput().val()
        authors: @authors.toJSON()

      queryInput = @queryInput()
      focusOffset = queryInput.val().length * 2
      queryInput.focus()
      queryInput[0].setSelectionRange(focusOffset, focusOffset)

      @

    events:
      'keyup input[name="query"]': 'search'
      'click a.add-author': 'addAuthor'

    search: _.debounce ->
      @authors.fetch
        data: name: @queryInput().val()
        reset: true
    , 300

    addAuthor: (e) ->
      e.preventDefault()
      @_addAuthor()

    _addAuthor: _.once ->
      @authors.create name: @queryInput().val()
