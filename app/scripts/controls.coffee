define [], ->
  class Controls
    KEYS: {
      32: 'space',
      37: 'left',
      39: 'right',
    }

    FULL_ANGLE = 20
    asEvented.call(Controls.prototype)

    constructor: ->
      @keys = {}
      @tilt = 0
      @clickObservers = []
      @inputVector =
        x: 0
        y: 0
      $(window)
        .on('keydown', @onKeyDown.bind(@))
        .on('keyup', @onKeyUp.bind(@))
        .on('deviceorientation', @onOrientation.bind(@))
        .on('touchstart', @onTouch.bind(@))
        .on('click', @onTouch.bind(@))

    onKeyDown: (e) ->
      if e.keyCode of @KEYS
        @keys[@KEYS[e.keyCode]] = true
      this.trigger('keydown', e)

    onKeyUp: (e) ->
      if e.keyCode of @KEYS
        @keys[@KEYS[e.keyCode]] = false
      this.trigger('keyup', e)

    update: (dt) ->
      if @keys.right
        @inputVector.x = 1
      else if @keys.left
        @inputVector.x = -1
      else
        @inputVector.x = 0

      if @inputVector.x == 0
        @inputVector.x = @tilt

    onTouch: (e) ->
      console.log "touched"
      this.trigger('touch', e)

    onOrientation: (e) ->
      degree = e.gamma
      if window.orientation
        direction = window.orientation / 90
        degree = direction * e.beta
      speed = degree / FULL_ANGLE
      if speed > 1
        speed = 1
      else if speed < -1
        speed = -1
      else if Math.abs(speed) < 0.3
        speed = 0
      @tilt = speed

  return new Controls
