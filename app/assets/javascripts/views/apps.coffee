define [
  'backbone'
  'handlebars'
  'text!templates/apps.hbs'
  'views/menu'
], (Backbone, Handlebars, template, Menu) ->

  class Apps extends Backbone.View

    initialize: (opts) ->
      @mainEl = opts.mainEl
      @menuView = new Menu opts

      @listenTo @menuView, 'close', @closeMenu

    @template: Handlebars.compile(template)

    render: ->
      @$el.html Apps.template
      @

    events:
      'click a.menu': 'showMenu'

    showMenu: (e) ->
      e.preventDefault()
      @mainEl.replace @menuView

    closeMenu: ->
      @mainEl.replace @
