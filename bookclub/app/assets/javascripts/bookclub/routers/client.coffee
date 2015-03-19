define [
  'backbone'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/auth/session'
  'bookclub/models/note'
  'bookclub/collections/notes'
  'bookclub/views/index'
  'bookclub/views/show-note'
  'bookclub/views/new-note'
], (Backbone, ElManager, Session, Note, Notes, Index, ShowNote, NewNote) ->

  class ClientRouter extends Backbone.Router

    initialize: (config) ->
      @el = $("#main")
      _.extend @, ElManager

      @initialNotes = new Notes config.initialNotes
      @currentNote = new Note config.currentNote if config.currentNote
      @lastNoteCreated = new Note config.lastNoteCreated if config.lastNoteCreated

      @session = new Session config.account
      @index = new Index
        collection: @initialNotes
        router: @
        nextPageQuery: config.nextPageQuery
        lastNoteCreated: @lastNoteCreated

    routes:
      ''            : 'index'
      'notes/new'   : 'newNote'
      'notes/:guid' : 'showNote'

    index: -> @setView @index

    newNote: ->
      if @session
        view = new NewNote
        @setView view
      else
        alert "NEED TO IMPLEMENT SIGN IN"

    showNote: (opts) ->
      view = if @currentNote?.get("guid") == opts.guid
        new ShowNote note: @currentNote
      else
        new ShowNote opts

      @setView view
