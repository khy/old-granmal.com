define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'bookclub/views/show-note'
  'bookclub/views/new-note'
  'text!bookclub/templates/index.hbs'
], ($, _, Backbone, Handlebars, ShowNote, NewNote, template) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      @app = opts.app
      @nextPageQuery = @app.nextPageQuery

      @listenTo @collection, 'add', @render
      @listenTo @collection, 'change', @render

    render: ->
      @$el.html Index.template
        notes: @collection.toJSON()
        hasNextPage: !_.isUndefined @nextPageQuery

      @

    events:
      'click ol.notes > li.note': 'showNote'
      'click a.new-note': 'newNote'
      'click li.load-more a': 'loadMore'

    showNote: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      note = @collection.get(guid)
      view = new ShowNote note: note
      @listenTo view, 'close', @closeShowNote
      @app.mainEl.replace view
      @app.router.navigate("notes/#{note.id}")

    closeShowNote: ->
      @app.mainEl.replace @, hard: true
      @app.router.navigate("")

    newNote: (e) ->
      e.preventDefault()
      view = new NewNote app: @app
      @listenTo view, 'close', @closeNewNote
      @app.mainEl.replace view

    closeNewNote: ->
      @app.mainEl.replace @, hard: true

    loadMore: (e) ->
      e.preventDefault()

      if !_.isUndefined @nextPageQuery
        jqXHR = @collection.fetch
          data: @nextPageQuery
          remove: false

        jqXHR.done (data, status, jqXHR) =>
          @nextPageQuery = jqXHR.getResponseHeader("X-Next-Page-Query")
