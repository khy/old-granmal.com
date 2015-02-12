define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Session

    constructor: (account) ->
      _.extend @, Backbone.Events
      @create(account)

    create: (account) =>
      @account = account
      unless _.isUndefined @account
        @trigger 'create', @account

    destroy: =>
      oldAccount = @account
      @account = undefined
      unless _.isUndefined oldAccount
        @trigger 'destroy', oldAccount
