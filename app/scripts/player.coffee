define ['controls'], (controls) ->
  class Player

    SPEED: 70
    JUMP_VELOCITY: 1100
    MAX_SPEED: 400
    GRAVITY: 3000
    PLATFORM_OFFSET: 10

    constructor: (el, @gameScene) ->
      @el = el
      @flip = 1
      @pos =
        x: 0
        y: 0
      @velocity =
        x: 0
        y: 0
      @jumping = false
      @flip = 1

      ratio = @gameScene.game.ratio
      @SPEED *= ratio.x
      @JUMP_VELOCITY *= ratio.y
      @MAX_SPEED *= ratio.x
      @GRAVITY *= ratio.y
      @PLATFORM_OFFSET *= ratio.x
      return

    update: (delta) ->
      # Left and right movement

      if controls.inputVector.x != 0
        @velocity.x += @SPEED * controls.inputVector.x
        if controls.inputVector.x > 0
          @flip = -1
        else
          @flip = 1

      # Cap MAX_SPEED
      if @velocity.x < -@MAX_SPEED
        @velocity.x = -@MAX_SPEED
      if @velocity.x > @MAX_SPEED
        @velocity.x = @MAX_SPEED

      # Warp the x-axis
      if @pos.x < 0
        @pos.x = @gameScene.width
      else if @pos.x > @gameScene.width
        @pos.x = 0

      # Jump
      if not @jumping
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
      for platform in @gameScene.platformManager.platforms
        if @pos.y > platform.rect.y and platform.rect.y >= oldY
          if @pos.x > platform.rect.x - @PLATFORM_OFFSET and @pos.x < platform.rect.right + @PLATFORM_OFFSET
            @pos.y = platform.rect.y
            @velocity.y = 0
            @jumping = false

    render: (camera) ->
      # Update UI
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@pos.x}px,#{@pos.y - camera.position}px) scale(#{@flip}, 1)"

  return Player
