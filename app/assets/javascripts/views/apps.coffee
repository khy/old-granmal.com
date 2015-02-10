define [
  'backbone'
  'handlebars'
  'text!templates/apps.hbs'
  'module'
  'views/menu'
], (Backbone, Handlebars, template, module, Menu) ->

  class Apps extends Backbone.View

    initialize: (opts) ->
      @app = opts.app

      @menu = new Menu app: @app
      @listenTo @menu, 'close', @closeMenu

    @template: Handlebars.compile(template)

    render: ->
      @$el.html Apps.template
      @

    events:
      'click a.menu': 'showMenu'

    showMenu: (e) ->
      e.preventDefault()
      @app.mainEl.replace @menu

    closeMenu: ->
      @app.mainEl.replace @
