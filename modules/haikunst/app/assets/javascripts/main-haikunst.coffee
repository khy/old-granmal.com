requirejs.config
  paths:
    lib: '../lib/lib'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
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
  'haikunst/routers/client'
  'bootstrap'
], ($, Backbone, Page, Header, ClientRouter, bootstrap) ->

  window.router = new ClientRouter bootstrap

  $(document).ready ->
    Page.ensureFullPage()
    Header.init()
    Backbone.history.start root: "haikunst", pushState: true
