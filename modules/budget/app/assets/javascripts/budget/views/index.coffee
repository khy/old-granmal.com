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
  'budget/views/new-projection'
  'budget/collections/projections'
], ($, _, Backbone, Handlebars, ElManager, Alert, template, NewAccount, Accounts, NewProjection, Projections) ->

  class Index extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts) ->
      _.extend @, ElManager
      @router = opts.router
      @session = opts.session
      @accounts = new Accounts opts.accounts
      @projections = new Projections opts.projections

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

    newProjection: (e) ->
      e?.preventDefault()
      newProjection = new NewProjection

      closeNewProjection = =>
        @setView @
        @router.navigate("")

      @listenTo newProjection, 'close', closeNewProjection

      @listenTo newProjection, 'create', (projection) ->
        @projections.unshift projection
        Alert.success "Created new projection \"#{projection.get('name')}\""
        closeNewProjection()

      @setView newProjection
      @router.navigate("projections/new")
