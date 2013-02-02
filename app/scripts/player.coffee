define ['controls'], (controls) ->
  class Player

    SPEED: 70
    JUMP_VELOCITY: 900
    MAX_SPEED: 400
    GRAVITY: 3000
    PLATFORM_OFFSET: 10

    constructor: (el, @game) ->
      @el = el
      @flip = 1
      @pos =
        x: 0
        y: 500
      @velocity =
        x: 0
        y: 0
      @jumping = false
      @flip = 1

    update: (delta) ->
      # Left and right movement
      if controls.keys.right
        @velocity.x += @SPEED
        @flip = -1
      if controls.keys.left
        @velocity.x -= @SPEED
        @flip = 1

      # Cap MAX_SPEED
      if @velocity.x < -@MAX_SPEED
        @velocity.x = -@MAX_SPEED
      if @velocity.x > @MAX_SPEED
        @velocity.x = @MAX_SPEED

      # Warp the x-axis
      if @pos.x < 0
        @pos.x = @game.width
      else if @pos.x > @game.width
        @pos.x = 0

      # Jump
      if not @jumping and @velocity.y == 0
        @velocity.y = -@JUMP_VELOCITY
        @jumping = true

      # Drag and GRAVITY
      @velocity.x *= 0.85
      @velocity.y += delta * @GRAVITY

      # Update position
      oldY = @pos.y
      @pos.x += delta * @velocity.x
      @pos.y += delta * @velocity.y

      # Check for collisions
      @checkPlatforms oldY

    checkPlatforms: (oldY) ->
      for platform in @game.platformManager.platforms
        if @pos.y > platform.rect.y and platform.rect.y >= oldY
          if @pos.x > platform.rect.x - @PLATFORM_OFFSET and @pos.x < platform.rect.right + @PLATFORM_OFFSET
            @pos.y = platform.rect.y
            @velocity.y = 0
            @jumping = false

    render: (camera) ->
      # Update UI
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@pos.x}px,#{@pos.y - camera.position}px) scale(#{@flip}, 1)"

  return Player
