requirejs.config
  baseUrl: '/assets/javascripts'
  paths:
    jquery: '/assets/lib/jquery/jquery'

require ['bookclub/app'], (app) -> app.init()
