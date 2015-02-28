###
A mixin that ensures that only a single view is ever listening to events
on a jQuery element defined by the `el` property on the parent object.
###

define ->

  setView: (view) ->
    previousView = @currentView
    @currentView = view
    previousView?.undelegateEvents()
    @currentView.setElement @el
    @currentView.render()
    previousView
