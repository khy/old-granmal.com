define ->

  class ViewEl

    constructor: (@el) ->

    replace: (view, opts = {}) ->
      view.beforeInsert?(@el)
      previousView = @currentView
      @currentView = view
      @currentView.render()
      @currentView.delegateEvents()
      @el.html @currentView.el

      if opts.hard
        previousView?.remove()
      else
        previousView?.undelegateEvents()

      @currentView.afterInsert?(@el)
      @currentView
