define [
  'jquery'
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/el-manager'
  'routers/server'
  'views/auth'
  'text!templates/menu.hbs'
], ($, _, Backbone, Handlebars, ElManager, ServerRouter, Auth, template) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      _.extend @, ElManager

      @session = opts.session
      @router = opts.router
      @authView = new Auth opts

      @listenTo @session, 'all', @render
      @listenTo @authView, 'close', -> @setView @

    render: ->
      @$el.html Menu.template account: @session.account
      @

    navigate: -> @router.navigate ''

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

    close: (e) ->
      e.preventDefault()
      @trigger 'close'

    remove: ->
      @authView.remove()
      super
