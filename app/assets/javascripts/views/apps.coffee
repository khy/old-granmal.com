define [
  'backbone'
  'handlebars'
  'text!templates/apps.hbs'
  'views/menu'
], (Backbone, Handlebars, template, Menu) ->

  class Apps extends Backbone.View

    initialize: (opts) ->
      @mainEl = opts.mainEl
      @router = opts.router
      @menuView = new Menu opts

      @listenTo @menuView, 'close', @closeMenu

    @template: Handlebars.compile(template)

    render: ->
      @$el.html Apps.template
      @

    navigate: -> @router.navigate ''

    events:
      'click a.menu': 'showMenu'

    showMenu: (e) ->
      e.preventDefault()
      @mainEl.replace @menuView
      @menuView.navigate()

    closeMenu: ->
      @mainEl.replace @
      @navigate()
