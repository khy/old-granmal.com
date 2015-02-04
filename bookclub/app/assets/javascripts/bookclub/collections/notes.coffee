define [
  'backbone'
  'bookclub/models/note'
  'bookclub/routers/server'
], (Backbone, Note, ServerRouter) ->

  class Notes extends Backbone.Collection

    model: Note

    url: ServerRouter.findNotes().url
