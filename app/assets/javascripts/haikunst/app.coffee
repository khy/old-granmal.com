define ['jquery', 'lib'], ($, lib) ->

  init: ->
    console.debug 'Initializing Haikunst!...'
    lib.ensureFullPage('.haikus')
    lib.ensureFullPage('.form-section')
    lib.ensureFullPage('.menu')
