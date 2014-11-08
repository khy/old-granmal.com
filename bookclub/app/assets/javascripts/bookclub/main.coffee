requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: '/assets/lib/jquery/jquery'
    underscore: '/assets/lib/underscorejs/underscore'
    backbone: '/assets/lib/backbonejs/backbone'
    handlebars: '/assets/lib/handlebars/handlebars'
  shim:
    handlebars:
      exports: 'Handlebars'

require ['bookclub/app'], (App) ->
  window.App = new App
  window.App.init()
