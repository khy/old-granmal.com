requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    lib: 'lib/lib'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
    moment: '../lib/momentjs/moment'
  shim:
    handlebars:
      exports: 'Handlebars'

require ['app'], (app) ->
  app.initMasthead()
