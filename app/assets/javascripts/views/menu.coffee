define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/backbone/el-manager'
  'utils/alert'
  'routers/server'
  'views/auth'
  'text!templates/menu.hbs'
], ($, _, Backbone, Handlebars, ElManager, Alert, ServerRouter, Auth, template) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      _.extend @, ElManager

      @session = opts.session
      @router = opts.router
      @authView = new Auth opts

      @listenTo @session, 'create', (account) =>
        @trigger 'close'
        Alert.success 'Signed in'

      @listenTo @authView, 'close', ->
        @setView @
        @router.navigate ''

    render: ->
      @$el.html Menu.template account: @session.account
      @

    events:
      'click a.sign-in': 'showAuthView'
      'click a.sign-out': 'signOut'
      'click a.close': 'close'

    showAuthView: (e) ->
      e.preventDefault()
      @setView @authView

    signOut: (e) ->
      e.preventDefault()
      jqxhr = ServerRouter.signOut.ajax()
      jqxhr.done =>
        @session.destroy()
        @trigger 'close'
        Alert.success 'Signed out'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'

    remove: ->
      @authView.remove()
      super
