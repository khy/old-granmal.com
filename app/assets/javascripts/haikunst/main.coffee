requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: 'vendor/jquery-2.1.0'

require ['haikunst/app'], (app) -> app.init()
