define [
  'backbone'
], (Backbone) ->

  class Account extends Backbone.Model

    idAttribute: "guid"
