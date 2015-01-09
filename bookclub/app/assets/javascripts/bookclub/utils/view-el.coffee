define ->

  class ViewEl

    constructor: (@el) ->

    insertView: (view) ->
      previousView = @currentView
      @currentView = view
      @currentView.render()
      @el.html @currentView.el
      previousView?.remove()
