define [
  'underscore'
  'handlebars'
  'text!lib/templates/form/field.hbs'
  'text!lib/templates/form/formError.hbs'
], (_, Handlebars, rawFieldTemplate, rawFormErrorTemplate) ->

  fieldTemplate = Handlebars.compile rawFieldTemplate
  formErrorTemplate = Handlebars.compile rawFormErrorTemplate

  buildFields: (values, errors) ->
    fields = {}
    _.each values, (value, key) ->
      fields[key] = value: value, errors: errors[key]
    fields

  registerHelpers: (Handlebars) ->
    Handlebars.registerHelper 'field', (context, options) ->
      raw = fieldTemplate
        input: options.fn context?.value
        errors: context?.errors

      new Handlebars.SafeString raw

    Handlebars.registerHelper 'formError', (context) ->
      raw = formErrorTemplate context
      new Handlebars.SafeString raw
