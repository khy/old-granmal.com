define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'routers/server'
], ($, _, Backbone, Handlebars, ServerRouter) ->

  class AuthorSelector extends Backbone.View

    template: Handlebars.compile($('#author-selector-template').html())

    render: ->
      @$el.html @template()

    events:
      'keyup input[name="name"]': 'search'

    search: _.debounce ->
      name = @$('input[name="name"]').val()

      $.ajax ServerRouter.findAuthors(name), (data) ->
        console.log data
    , 300
