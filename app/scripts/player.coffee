define ['controls'], (controls) ->
  class Player
    acceleration:
      x: 70
      y: -900
    speed: 400
    gravity: 3000

    constructor: (el, @game) ->
      @el = el
      @pos =
        x: 0
        y: 0
      @velocity =
        x: 0
        y: 0
      @jumping = false
      @flip = 1

    onFrame: (delta) ->
      if controls.keys.right
        @velocity.x += @acceleration.x
        @flip = -1
      if controls.keys.left
        @velocity.x -= @acceleration.x
        @flip = 1

      #cap speed
      if @velocity.x < -@speed
        @velocity.x = -@speed
      if @velocity.x > @speed
        @velocity.x = @speed

      if controls.keys.space and not @jumping
        @velocity.y = @acceleration.y
        @jumping = true

      
      oldY = @pos.y
      @pos.x += delta * @velocity.x
      @pos.y += delta * @velocity.y

      #drag
      @velocity.x *= 0.85
      @velocity.y += delta * @gravity

      @checkPlatforms oldY
      if @pos.y > 0
        @pos.y = 0
        @velocity.y = 0
        @jumping = false
      
      # Update UI
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@pos.x}px,#{@pos.y}px) scale(#{@flip}, 1)"

    checkPlatforms: (oldY) ->
      for platform in @game.platforms
        if oldY < platform.rect.y and @pos.y >= platform.rect.y
          @pos.y = platform.rect.y
          @velocity.y = 0
          @jumping = false

  return Player
