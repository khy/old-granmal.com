define [
  'jquery'
  'backbone'
  'handlebars'
  'routers/server'
  'views/auth'
  'text!templates/menu.hbs'
], ($, Backbone, Handlebars, ServerRouter, Auth, template) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @mainEl = opts.mainEl
      @session = opts.session
      @router = opts.router
      @authView = new Auth opts

      @listenTo @session, 'all', @render
      @listenTo @authView, 'close', @closeAuthView

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
      @mainEl.replace @authView

    closeAuthView: ->
      @mainEl.replace @
      @navigate()

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
