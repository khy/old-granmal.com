requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    lib: '/assets/javascripts/lib/lib'
    jquery: '/assets/lib/jquery/jquery'
    underscore: '/assets/lib/underscorejs/underscore'
    backbone: '/assets/lib/backbonejs/backbone'
    handlebars: '/assets/lib/handlebars/handlebars'
    moment: '/assets/lib/momentjs/moment'
  shim:
    handlebars:
      exports: 'Handlebars'

require ['app'], (app) ->
  app.initMasthead()
