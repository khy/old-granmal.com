define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/backbone/prestitial'
  'lib/javascripts/auth/session'
  'bookclub/models/note'
  'bookclub/collections/notes'
  'bookclub/views/index'
  'bookclub/views/show-note'
  'bookclub/views/new-note'
], (Backbone, ElManager, Prestitial, Session, Note, Notes, Index, ShowNote, NewNote) ->

  class ClientRouter extends Backbone.Router

    initialize: (config) ->
      @el = $("#main")
      _.extend @, ElManager

      @showPrestitial = config.showPrestitial || true
      @initialNotes = new Notes config.initialNotes
      @currentNote = new Note config.currentNote if config.currentNote
      @lastNoteCreated = new Note config.lastNoteCreated if config.lastNoteCreated

      @session = new Session config.account
      @index = new Index
        collection: @initialNotes
        router: @
        session: @session
        nextPageQuery: config.nextPageQuery
        lastNoteCreated: @lastNoteCreated

    routes:
      ''            : 'index'
      'notes/new'   : 'newNote'
      'notes/:guid' : 'showNote'

    index: ->
      if @showPrestitial
        prestitial = new Prestitial el: @el
        @listenTo prestitial, 'continue', ->
          @showPrestitial = false
          @setView @index
        @setView prestitial
      else
        @setView @index

    newNote: ->
      view = new NewNote
      @setView view

    showNote: (opts) ->
      view = if @currentNote?.get("guid") == opts.guid
        new ShowNote note: @currentNote
      else
        new ShowNote opts

      @setView view
