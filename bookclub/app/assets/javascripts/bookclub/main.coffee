requirejs.config
  baseUrl: '/assets/javascripts/bookclub'
  paths:
    lib: '../lib/lib/javascripts'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
    moment: '../lib/momentjs/moment'
  shim:
    handlebars:
      exports: 'Handlebars'

require ['app'], (App) ->
  window.App = new App
  window.App.init()
