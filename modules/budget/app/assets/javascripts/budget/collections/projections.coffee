define [
  'backbone'
  'budget/models/projection'
], (Backbone, Projection) ->

  class Projections extends Backbone.Collection

    model: Projection
