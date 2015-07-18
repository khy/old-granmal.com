define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Session

    constructor: (account) ->
      _.extend @, Backbone.Events
      @create(account)

    isSignedIn: -> _.isObject @account

    create: (account) ->
      @account = account
      if _.isObject @account
        @trigger 'create', @account

    destroy: ->
      oldAccount = @account
      @account = undefined
      if _.isObject oldAccount
        @trigger 'destroy', oldAccount
