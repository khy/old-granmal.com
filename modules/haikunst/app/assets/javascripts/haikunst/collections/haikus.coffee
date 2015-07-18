define [
  'backbone'
  'haikunst/models/haiku'
], (Backbone, Haiku) ->

  class Haikus extends Backbone.Collection

    model: Haiku
