define ['controls'], (controls) ->
  class Player
    acceleration:
      x: 70
      y: -900
    speed: 400
    gravity: 3000

    constructor: (el) ->
      @el = el
      @pos =
        x: 0
        y: 0
      @velocity =
        x: 0
        y: 0
      @jumping = false

    onFrame: (delta) ->
      if controls.keys.right
        @velocity.x += @acceleration.x
      if controls.keys.left
        @velocity.x -= @acceleration.x

      #cap speed
      if @velocity.x < -@speed
        @velocity.x = -@speed
      if @velocity.x > @speed
        @velocity.x = @speed

      if controls.keys.space and not @jumping
        @velocity.y = @acceleration.y
        @jumping = true

      
      @pos.x += delta * @velocity.x
      @pos.y += delta * @velocity.y

      #drag
      @velocity.x *= 0.85
      @velocity.y += delta * @gravity

      if @pos.y > 0
        @pos.y = 0
        @velocity.y = 0
        @jumping = false
      
      # Update UI
      @el.css '-webkit-transform', "translate(#{@pos.x}px,#{@pos.y}px)"

  return Player
