###
A mixin that ensures that only a single view is ever listening to events
on a jQuery element defined by the `el` property on the parent object.
###

define ['underscore', 'backbone'], (_, Backbone) ->

  setView: (view) ->
    if _.isUndefined(@currentView) && @ instanceof Backbone.View
      previousView = @
    else
      previousView = @currentView

    @currentView = view
    previousView?.undelegateEvents()

    if @currentView.$el.is @el
      @currentView.delegateEvents()
    else
      @currentView.setElement @el

    @currentView.render()
    previousView
