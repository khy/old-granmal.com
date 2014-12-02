define ['underscore'], (_) ->

  isMissing: (value) -> !_.isNumeric(value) and _.isEmpty(value)

  isNumeric: (value) -> !_.isNaN(parseFloat(value))

  isInteger: (value) -> parseInt(value) == parseFloat(value)

  isNegative: (value) -> parseFloat(value) < 0 if @isNumeric(value)

  isPositive: (value) -> parseFloat(value) > 0 if @isNumeric(value)

  isGreaterThan: (this, that) ->
    if @isNumeric(this) and @isNumeric(that)
      parseFloat(this) > parseFloat(that)

  isLessThan: (this, that) ->
    if @isNumeric(this) and @isNumeric(that)
      parseFloat(this) < parseFloat(that)
