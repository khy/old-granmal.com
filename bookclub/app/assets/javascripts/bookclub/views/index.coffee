define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/handlebars/markdown'
  'bookclub/views/show-note'
  'bookclub/views/new-note'
  'text!bookclub/templates/index.hbs'
], ($, _, Backbone, Handlebars, ElManager, Markdown, ShowNote, NewNote, template) ->

  Markdown.registerHelpers Handlebars

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager

      @router = opts.router
      @session = opts.session
      @lastNoteCreated = opts.lastNoteCreated
      @nextPageQuery = opts.nextPageQuery

      @listenTo @collection, 'add', @render
      @listenTo @collection, 'change', @render

    render: ->
      @$el.html Index.template
        notes: @collection.toJSON()
        hasNextPage: !_.isUndefined @nextPageQuery

      @

    events:
      'click ol.notes > li.note': 'showNote'
      'click a.new-note': 'showNewNote'
      'click li.load-more a': 'loadMore'

    showNote: (e) ->
      e.preventDefault()
      guid = $(e.currentTarget).data('guid')
      note = @collection.get(guid)
      view = new ShowNote note: note
      @listenTo view, 'close', @closeShowNote
      @setView view
      @router.navigate("notes/#{note.id}")

    closeShowNote: ->
      @setView @
      @router.navigate("")

    showNewNote: (e) ->
      e.preventDefault()

      view = new NewNote
        router: @router
        session: @session
        lastNoteCreated: @lastNoteCreated

      @listenTo view, 'close', @closeNewNote
      @listenTo view, 'create', (note) ->
        @collection.unshift note
        @closeNewNote()

      @setView view
      @router.navigate("notes/new")

    closeNewNote: ->
      @setView @
      @router.navigate("")

    loadMore: (e) ->
      e.preventDefault()

      if !_.isUndefined @nextPageQuery
        jqXHR = @collection.fetch
          data: @nextPageQuery
          remove: false

        jqXHR.done (data, status, jqXHR) =>
          @nextPageQuery = jqXHR.getResponseHeader("X-Next-Page-Query")
