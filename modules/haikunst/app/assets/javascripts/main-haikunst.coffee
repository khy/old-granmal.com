requirejs.config
  paths:
    lib: '../lib/lib'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'

require [
  'jquery'
  'lib/javascripts/page'
  'lib/javascripts/ui/header'
], ($, page, Header) ->
  $(document).ready ->
    page.ensureFullPage()
    Header.init()
