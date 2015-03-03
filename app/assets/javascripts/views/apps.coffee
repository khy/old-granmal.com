define [
  'underscore'
  'backbone'
  'handlebars'
  'lib/javascripts/el-manager'
  'text!templates/apps.hbs'
  'views/masthead'
  'views/menu'
], (_, Backbone, Handlebars, ElManager, template, Masthead, Menu) ->

  class Apps extends Backbone.View

    initialize: (opts) ->
      _.extend @, ElManager

      @router = opts.router
      @menuView = new Menu opts
      @shouldShowMasthead = true

      @listenTo @menuView, 'close', -> @setView @

    @template: Handlebars.compile(template)

    render: ->
      if @shouldShowMasthead
        @showMasthead()
      else
        @$el.html Apps.template

      @

    navigate: -> @router.navigate ''

    events:
      'click a.menu': 'showMenu'

    showMasthead: ->
      view = new Masthead
      @listenToOnce view, 'close', ->
        @shouldShowMasthead = false
        @setView @
      @setView view

    showMenu: (e) ->
      e.preventDefault()
      @setView @menuView
