requirejs.config
  paths:
    lib: '../lib/lib'
    jquery: '../lib/jquery/jquery'
    underscore: '../lib/underscorejs/underscore'
    backbone: '../lib/backbonejs/backbone'
    handlebars: '../lib/handlebars/handlebars'
    moment: '../lib/momentjs/moment'
    markdown: '../lib/markdown-js/markdown'
    text: '../lib/lib/javascripts/requirejs/text'
  shim:
    handlebars:
      exports: 'Handlebars'
    markdown:
      exports: 'markdown'

define 'bootstrap', ['module'], (module) -> module.config()

require [
  'jquery'
  'backbone'
  'lib/javascripts/page'
  'bookclub/routers/client'
  'bootstrap'
], ($, Backbone, Page, ClientRouter, bootstrap) ->
  window.router = new ClientRouter bootstrap

  $(document).ready ->
    Page.ensureFullPage()
    Backbone.history.start root: "book-club", pushState: true
