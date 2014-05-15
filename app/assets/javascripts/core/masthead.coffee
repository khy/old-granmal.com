requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: 'vendor/jquery-2.1.0'

require ['core/app'], (app) -> app.initMasthead()
