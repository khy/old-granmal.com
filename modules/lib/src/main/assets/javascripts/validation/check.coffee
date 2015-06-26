define ['underscore'], (_) ->

  guidRx = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/

  isPresent: (value) -> @isNumber(value) or !_.isEmpty(value)

  isMissing: (value) -> !@isPresent(value)

  isNumber: (value) -> _.isNumber(value)

  isNumeric: (value) -> !_.isNaN(parseFloat(value))

  isInteger: (value) -> parseInt(value) == parseFloat(value)

  isNegative: (value) -> parseFloat(value) < 0 if @isNumeric(value)

  isPositive: (value) -> parseFloat(value) > 0 if @isNumeric(value)

  isGreaterThan: (_this, _that) ->
    if @isNumeric(_this) and @isNumeric(_that)
      parseFloat(_this) > parseFloat(_that)

  isLessThan: (_this, _that) ->
    if @isNumeric(_this) and @isNumeric(_that)
      parseFloat(_this) < parseFloat(_that)

  isGuid: (value) -> guidRx.test(value)
