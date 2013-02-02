define ['controls'], (controls) ->
  class Player

    SPEED: 70
    JUMP_VELOCITY: 1100
    MAX_SPEED: 400
    GRAVITY: 3000
    PLATFORM_OFFSET: 10
    DRAG: 0.85
    PLAYER_SIZE: {x: 100, y: 97}
    PLAYER_MARGINS: {top: -95, left:-48}

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
      @SPEED *= ratio
      @JUMP_VELOCITY *= ratio
      @MAX_SPEED *= ratio
      @GRAVITY *= ratio
      @PLATFORM_OFFSET *= ratio
      @PLAYER_SIZE.x *= ratio
      @PLAYER_SIZE.y *= ratio
      @PLAYER_MARGINS.top *= ratio
      @PLAYER_MARGINS.left *= ratio
      el.width(@PLAYER_SIZE.x)
      el.height(@PLAYER_SIZE.y)
      el.css {
        'margin-top': "#{@PLAYER_MARGINS.top}px",
        'margin-left': "#{@PLAYER_MARGINS.left}px"
      }
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
      @velocity.x *= @DRAG
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
          if @pos.x > platform.rect.left - @PLATFORM_OFFSET and @pos.x < platform.rect.right + @PLATFORM_OFFSET
            @pos.y = platform.rect.y
            @velocity.y = 0
            @jumping = false

    render: (camera) ->
      # Update UI
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@pos.x}px,#{@pos.y - camera.position}px) scale(#{@flip}, 1)"

  return Player
