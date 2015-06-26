requirejs.config
  paths:
    lib: '../lib/lib/javascripts'
    jquery: '../lib/jquery/jquery'

require ['jquery', 'lib/page'], ($, page) ->
  $(document).ready ->
    page.ensureFullPage()
