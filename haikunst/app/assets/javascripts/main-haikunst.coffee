requirejs.config
  paths:
    lib: '../lib/lib/javascripts'
    jquery: '../lib/jquery/jquery'

require ['lib/page'], (page) ->
  page.ensureFullPage()
