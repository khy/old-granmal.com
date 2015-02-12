define [
  'jquery'
  'backbone'
  'handlebars'
  'text!templates/menu.hbs'
], ($, Backbone, Handlebars, template) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile template

    initialize: (opts) ->
      @app = opts.app

      @listenTo @app.session, 'all', @render
      @listenTo @app.authView, 'close', @closeAuthView

    render: ->
      @$el.html Menu.template account: @app.session.account
      @

    events:
      'click a.sign-in': 'showAuthView'
      'click a.sign-out': 'signOut'
      'click a.close': 'close'

    showAuthView: (e) ->
      e.preventDefault()
      @app.mainEl.replace @app.authView

    closeAuthView: ->
      @app.mainEl.replace @

    signOut: (e) ->
      e.preventDefault()
      jqxhr = $.ajax type: 'DELETE', url: '/session'
      jqxhr.done =>
        @app.session.destroy()
        @trigger 'close'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
