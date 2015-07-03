requirejs.config
  paths:
    lib: '../lib/lib'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
    moment: '../lib/momentjs/moment'
    text: '../lib/lib/javascripts/requirejs/text'
  shim:
    handlebars:
      exports: 'Handlebars'

define 'bootstrap', ['module'], (module) -> module.config()

require [
  'jquery'
  'backbone'
  'lib/javascripts/page'
  'lib/javascripts/ui/header'
  'routers/client'
  'bootstrap'
], ($, Backbone, Page, Header, ClientRouter, bootstrap) ->
  window.router = new ClientRouter bootstrap

  $(document).ready ->
    Page.ensureFullPage()
    Header.init()
    Backbone.history.start pushState: true
