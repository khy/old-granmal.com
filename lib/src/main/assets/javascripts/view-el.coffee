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
      @currentView.afterInsert?(@el)

      if opts.hard
        previousView?.remove()
      else
        previousView?.undelegateEvents()

      previousView

    clear: ->
      previousView = @currentView
      previousView?.undelegateEvents()
      @currentView = undefined
      previousView
