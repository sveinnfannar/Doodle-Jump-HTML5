define [], ->
  class Controls
    KEYS: {
      32: 'space',
      37: 'left',
      39: 'right',
    }

    FULL_ANGLE = 20

    constructor: ->
      @keys = {}
      @tilt = 0
      @inputVector =
        x: 0
        y: 0
      $(window)
        .on('keydown', @onKeyDown.bind(@))
        .on('keyup', @onKeyUp.bind(@))
        .on('deviceorientation', @onOrientation.bind(@))

    onKeyDown: (e) ->
      if e.keyCode of @KEYS
        @keys[@KEYS[e.keyCode]] = true

    onKeyUp: (e) ->
      if e.keyCode of @KEYS
        @keys[@KEYS[e.keyCode]] = false

    onFrame: (dt) ->
      if @keys.right
        @inputVector.x = 1
      else if @keys.left
        @inputVector.x = -1
      else
        @inputVector.x = 0

      if @inputVector.x == 0
        @inputVector.x = @tilt

    onOrientation: (e) ->
      degree = e.gamma
      if window.orientation
        alert window.orientation
        direction = window.orientation / 90
        degree = direction * e.beta
      speed = degree / FULL_ANGLE
      if speed > 1
        speed = 1
      else if speed < -1
        speed = -1
      @tilt = speed

  return new Controls
