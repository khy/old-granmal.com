define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'routers/server'
], ($, _, Backbone, Handlebars, ServerRouter) ->

  class AuthorSelector extends Backbone.View

    @template: Handlebars.compile($('#author-selector-template').html())

    initialize: ->
      @authors = new Backbone.Collection()
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

    search: _.debounce ->
      $.ajax(ServerRouter.findAuthors(@queryInput().val())).done (data) =>
        @authors.reset(data)
    , 300
