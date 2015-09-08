define [
  'jquery'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'budget/models/account'
  'text!budget/templates/new-account.hbs'
], ($, Backbone, Handlebars, ElManager, Account, template) ->

  class NewAccount extends Backbone.View

    @template: Handlebars.compile(template)

    initialize: (opts = {}) ->
      _.extend @, ElManager

      @account = new Account

    render: (title) ->
      @$el.html NewAccount.template
      @

    events:
      'submit form': 'createAccount'
      'click a.close': 'close'

    createAccount: (e) ->
      e.preventDefault()
      console.log "CREATE"

    close: (e) ->
      e?.preventDefault()
      @trigger 'close'
