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

require [
  'jquery'
  'backbone'
  'lib/javascripts/page'
  'lib/javascripts/ui/header'
  'haikunst/routers/server'
  'haikunst/routers/client'
], ($, Backbone, Page, Header, ServerRouter, ClientRouter) ->

  $(document).ready ->
    Page.ensureFullPage()
    ServerRouter.bootstrap().ajax().done (bootstrap) ->
      Header.init()
      window.router = new ClientRouter bootstrap
      Backbone.history.start root: "haikunst", pushState: true
