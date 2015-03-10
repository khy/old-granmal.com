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

require ['bookclub/app'], (App) ->
  window.App = new App
  window.App.init()
