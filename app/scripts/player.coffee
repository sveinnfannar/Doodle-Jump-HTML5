define ['controls'], (controls) ->
  class Player
    acceleration:
      x: 50
      y: 0
    speed: 200
    scaleSpeed: 0.1

    constructor: (el) ->
      @el = el
      @pos =
        x: 0
        y: 0
      @velocity =
        x: 0
        y: 0
      @scale = 1.0

    onFrame: (delta) ->
      if controls.keys.right
        @velocity.x += delta * @acceleration.x
      if controls.keys.left
        @velocity.x -= delta * @acceleration.x

      #cap speed
      if @velocity.x < -@speed
        @velocity.x = -@speed
      if @velocity.x > @speed
        @velocity.x = @speed
      if controls.keys.space
        @pos.x += delta * @speed
        @scale += delta * @scaleSpeed

      if @scale < 0.5 or @scale > 1
        @scaleSpeed *= -1
      
      @pos.x += @velocity.x

      #drag
      @velocity.x *= 0.85
      
      # Update UI
      @el.css '-webkit-transform', "scale(#{@scale}) translate(#{@pos.x}px,#{@pos.y}px)"

  return Player
