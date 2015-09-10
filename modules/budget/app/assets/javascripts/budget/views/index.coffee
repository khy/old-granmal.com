define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'lib/javascripts/alert'
  'text!budget/templates/index.hbs'
  'budget/views/new-account'
  'budget/collections/accounts'
], ($, _, Backbone, Handlebars, ElManager, Alert, template, NewAccount, Accounts) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @router = opts.router
      @session = opts.session
      @accounts = new Accounts opts.accounts

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

      @listenTo newAccount, 'create', (account) ->
        @accounts.unshift account
        Alert.success "Created new #{account.get('accountType')} account \"#{account.get('name')}\""
        closeNewAccount()

      @setView newAccount
      @router.navigate("accounts/new")
