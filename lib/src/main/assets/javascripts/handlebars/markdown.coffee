define [
  'handlebars'
  'markdown'
], (Handlebars, Markdown) ->

  registerHelpers: (Handlebars) ->
    Handlebars.registerHelper 'markdown', (context, options) ->
      new Handlebars.SafeString Markdown.toHTML(context)
