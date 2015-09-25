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

require [
  'jquery'
  'backbone'
  'lib/javascripts/page'
  'lib/javascripts/ui/header'
  'budget/routers/server'
  'budget/routers/client'
], ($, Backbone, Page, Header, ServerRouter, ClientRouter) ->

  $(document).ready ->
    Page.ensureFullPage()
    ServerRouter.Application.bootstrap().ajax().done (bootstrap) ->
      Header.init()
      console.debug bootstrap
      window.router = new ClientRouter bootstrap
      Backbone.history.start root: "budget", pushState: true
