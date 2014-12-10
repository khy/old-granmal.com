define [
  'backbone'
  'models/note'
  'routers/server'
], (Backbone, Note, ServerRouter) ->

  class Notes extends Backbone.Collection

    model: Note

    url: ServerRouter.findNotes().url
