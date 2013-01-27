define [], ->
  class Controls
    KEYS: {
      32: 'space',
      37: 'left',
      39: 'right',
    }
    constructor: ->
      @keys = {}
      $(window)
        .on('keydown', @onKeyDown.bind(@))
        .on('keyup', @onKeyUp.bind(@))
    onKeyDown: (e) ->
      if e.keyCode of @KEYS
        @keys[@KEYS[e.keyCode]] = true
    onKeyUp: (e) ->
      if e.keyCode of @KEYS
        @keys[@KEYS[e.keyCode]] = false

  return new Controls
