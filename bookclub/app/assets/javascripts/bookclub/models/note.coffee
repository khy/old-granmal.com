define [
  'backbone'
  'utils/validation'
], (Backbone, v) ->

  class Note extends Backbone.Model

    validate: (attrs) ->
      error = {}

      if v.isMissing(attrs.book_guid)
        error.book_guid = "missing"

      if v.isMissing(attrs.page_number)
        error.page_number = "missing"
      else if v.isInteger(attrs.page_number)
        error.page_number = "non-integer"
      else if v.isNegative(attrs.page_number)
        error.page_number = "negative"

      if v.isMissing(attrs.page_total)
        error.page_total = "missing"
      else if v.isInteger(attrs.page_total)
        error.page_total = "non-integer"
      else if v.isNegative(attrs.page_total)
        error.page_total = "negative"

      if v.isGreaterThan(attrs.page_number, attrs.page_total)
        error.page_number ||= "greater-than-page-total"

      if v.isMissing(attrs.content)
        error.content = "missing"

      if !_.isEmpty(error)
        @invalidAttributes = attrs
        error
