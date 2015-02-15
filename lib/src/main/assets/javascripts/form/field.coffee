define [
  'underscore'
  'handlebars'
  'text!lib/templates/form/field.hbs'
], (_, Handlebars, rawFieldTemplate) ->

  fieldTemplate = Handlebars.compile rawFieldTemplate

  buildData: (values, errors) ->
    context = {}
    _.each values, (value, key) ->
      context[key] = value: value, errors: errors[key]
    context


  registerHelpers: (Handlebars) ->
    Handlebars.registerHelper 'field', (context, options) ->
      raw = fieldTemplate
        input: options.fn context?.value
        errors: context?.errors

      new Handlebars.SafeString raw
