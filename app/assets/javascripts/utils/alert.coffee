define [
  'jquery'
  'underscore'
  'handlebars'
  'text!templates/alert.hbs'
], ($, _, Handlebars, rawTemplate) ->

  el = $(".alert")

  template = Handlebars.compile rawTemplate

  isActive = false

  display: (text, action, callback) ->
    # Drop calls made when active, for now.
    unless isActive
      isActive = true
      el.html template text: text
      el.show()
      _.delay ->
        el.hide()
        isActive = false
      , 5000
