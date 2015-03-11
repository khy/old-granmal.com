requirejs.config
  paths:
    lib: '../lib/lib/javascripts'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
    moment: '../lib/momentjs/moment'
    text: 'requirejs/text'
  shim:
    handlebars:
      exports: 'Handlebars'

define 'bootstrap', ['module'], (module) -> module.config()

require ['bookclub/app', 'bootstrap'], (App, bootstrap) ->
  window.App = new App bootstrap
  window.App.init()
