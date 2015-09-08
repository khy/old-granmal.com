define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'budget/views/new-account'
  'text!budget/templates/index.hbs'
], ($, _, Backbone, Handlebars, ElManager, NewAccount, template) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @router = opts.router
      @session = opts.session

    render: ->
      @$el.html Index.template

      @

    newAccount: (e) ->
      e?.preventDefault()
      newAccount = new NewAccount

      closeNewAccount = =>
        @setView @
        @router.navigate("")

      @listenTo newAccount, 'close', closeNewAccount

      @setView newAccount
      @router.navigate("accounts/new")
