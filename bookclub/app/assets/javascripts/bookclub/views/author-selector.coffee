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
      @listenTo @authors, 'reset', @render
      @listenTo @authors, 'sync', @selectNewAuthor

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
      'click a.existing-author': 'selectExistingAuthor'
      'click a.new-author': 'addAuthor'

    search: _.debounce ->
      query = @queryInput().val()

      if query.length > 0
        @authors.fetch
          data: name: query
          reset: true
    , 300

    selectNewAuthor: (collection, response) ->
      if !_.isUndefined(response.guid)
        @selectAuthor(response.guid)

    selectExistingAuthor: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      @selectAuthor(guid)

    selectAuthor: _.throttle (guid) ->
      selectedAuthor = @authors.get(guid)
      @trigger 'select', selectedAuthor
    , 1000

    addAuthor: (e) ->
      e.preventDefault()
      @_addAuthor()

    _addAuthor: _.throttle ->
      @authors.create name: @queryInput().val()
    , 1000
