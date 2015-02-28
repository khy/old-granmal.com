define [
  'backbone'
  'handlebars'
  'text!templates/masthead.hbs'
], (Backbone, Handlebars, template) ->

  class Masthead extends Backbone.View

    @template: Handlebars.compile(template)

    render: ->
      @$el.html Masthead.template
      @el.ontouchmove = (e) -> e.preventDefault()
      @$('.masthead .poster').height @$el.height() - 40
      @

    events:
      'click': (e) ->
        e.preventDefault()
        @trigger 'close'
