define [
  'backbone'
  'handlebars'
  'text!templates/menu.hbs'
], (Backbone, Handlebars, template) ->

  class Menu extends Backbone.View

    @template: Handlebars.compile(template)

    render: ->
      @$el.html Menu.template
      @

    events:
      'click a.close': 'close'

    close: (e) ->
      e.preventDefault()
      @trigger 'close'
