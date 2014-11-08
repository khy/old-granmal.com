requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: '/assets/lib/jquery/jquery'
    underscore: '/assets/lib/underscorejs/underscore'
    backbone: '/assets/lib/backbonejs/backbone'

require ['bookclub/app'], (app) -> app.init()
