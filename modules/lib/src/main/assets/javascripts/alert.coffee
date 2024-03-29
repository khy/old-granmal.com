define [
  'jquery'
  'underscore'
  'handlebars'
  'text!lib/templates/alert.hbs'
], ($, _, Handlebars, rawTemplate) ->

  el = $(".alert")

  template = Handlebars.compile rawTemplate

  show = -> el.fadeIn()

  hide = -> el.fadeOut()

  display = (klass, text, action, callback) ->
    hide()
    el.html template klass: klass, text: text, action: action
    el.off 'click'
    el.on 'click', hide
    unless _.isUndefined callback
      el.on 'click', '.alert-action', callback
    show()
    _.delay hide, 5000

  success: (text, action, callback) ->
    display 'success', text, action, callback

  info: (text, action, callback) ->
    display 'info', text, action, callback

  warning: (text, action, callback) ->
    display 'warning', text, action, callback

  danger: (text, action, callback) ->
    display 'danger', text, action, callback
