define [
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/el-manager'
  'text!templates/apps.hbs'
  'views/menu'
], (_, Backbone, Handlebars, ElManager, template, Menu) ->

  class Apps extends Backbone.View

    initialize: (opts) ->
      @currentView = @
      _.extend @, ElManager

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
      @setView @menuView

    closeMenu: ->
      @setView @
