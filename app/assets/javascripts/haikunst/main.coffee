requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: '/assets/lib/jquery/jquery'

require ['haikunst/app'], (app) -> app.init()
