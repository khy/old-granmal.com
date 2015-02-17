requirejs.config
  paths:
    lib: '../lib/lib'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
    moment: '../lib/momentjs/moment'
    text: 'requirejs/text'
  shim:
    handlebars:
      exports: 'Handlebars'

define 'main', [
  'jquery'
  'backbone'
  'lib/javascripts/page'
  'module'
  'routers/client'
], ($, Backbone, Page, module, ClientRouter) ->
  window.router = new ClientRouter module.config()

  $(document).ready ->
    Page.ensureFullPage()
    Backbone.history.start pushState: true
