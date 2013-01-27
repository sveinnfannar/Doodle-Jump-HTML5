define ['controls'], (controls) ->
  class Player
    acceleration:
      x: 70
      y: -900
    speed: 400
    gravity: 3000

    constructor: (el, @game) ->
      @el = el
      @flip = 1
      @pos =
        x: 0
        y: 0
      @velocity =
        x: 0
        y: 0

    onFrame: (delta) ->
      # Move left or right
      if controls.keys.right
        @velocity.x += @acceleration.x
        @flip = -1
      if controls.keys.left
        @velocity.x -= @acceleration.x
        @flip = 1

      # Cap left and right speed
      if @velocity.x < -@speed
        @velocity.x = -@speed
      if @velocity.x > @speed
        @velocity.x = @speed

      # Jumping
      @checkPlatforms oldY
      if @pos.y > 0
        @pos.y = 0
        @velocity.y = 0
        @velocity.y = @acceleration.y

      # Update the position
      oldY = @pos.y
      @pos.x += delta * @velocity.x
      @pos.y += delta * @velocity.y

      # Drag
      @velocity.x *= 0.85
      @velocity.y += delta * @gravity
      
      # Update UI
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@pos.x}px,#{@pos.y}px) scale(#{@flip}, 1)"

    checkPlatforms: (oldY) ->
      for platform in @game.platforms
        if oldY < platform.rect.y and @pos.y >= platform.rect.y
          @pos.y = platform.rect.y
          @velocity.y = 0
          @jumping = false

  return Player
