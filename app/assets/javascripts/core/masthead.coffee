requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: '/assets/lib/jquery/jquery'

require ['core/app'], (app) -> app.initMasthead()
