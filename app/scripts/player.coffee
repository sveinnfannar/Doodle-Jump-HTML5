define ['controls'], (controls) ->
  class Player

    SCALED = false
    SPEED = 70
    JUMP_VELOCITY = 1000
    MAX_SPEED = 400
    GRAVITY = 3000
    PLATFORM_OFFSET = 5
    DRAG = 0.85
    PLAYER_SIZE = {x: 60, y: 58}
    PLAYER_MARGINS = {top: -60, left:-28}

    constructor: (@gameScene) ->
      # Set up the elements
      @el = $('<div class="player">
        <div class="front_right_leg"></div>
        <div class="front_left_leg"></div>
        <div class="back_right_leg"></div>
        <div class="back_left_leg"></div>
        </div>')
      @legEls =
        frontRight: $('.front_right_leg')
        backRight: $('.back_right_leg')
        frontLeft: $('.front_left_leg')
        backLeft: $('.back_left_leg')

      @flip = 1
      @pos =
        x: 0
        y: 0
      @velocity =
        x: 0
        y: 0
      @jumping = false
      @flip = 1

      if not SCALED
        ratio = @gameScene.game.ratio
        SPEED *= ratio
        JUMP_VELOCITY *= ratio
        MAX_SPEED *= ratio
        GRAVITY *= ratio
        PLATFORM_OFFSET *= ratio
        PLAYER_SIZE.x *= ratio
        PLAYER_SIZE.y *= ratio
        PLAYER_MARGINS.top *= ratio
        PLAYER_MARGINS.left *= ratio
        SCALED = true
      @el.width(PLAYER_SIZE.x)
      @el.height(PLAYER_SIZE.y)
      @el.css {
        'margin-top': "#{PLAYER_MARGINS.top}px",
        'margin-left': "#{PLAYER_MARGINS.left}px"
      }
      return

    update: (delta) ->
      # Left and right movement
      if controls.inputVector.x != 0
        @velocity.x += SPEED * controls.inputVector.x
        if controls.inputVector.x > 0
          @flip = 1
        else
          @flip = -1

      # Cap MAX_SPEED
      if @velocity.x < -MAX_SPEED
        @velocity.x = -MAX_SPEED
      if @velocity.x > MAX_SPEED
        @velocity.x = MAX_SPEED

      # Warp the x-axis
      if @pos.x < 0
        @pos.x = @gameScene.width
      else if @pos.x > @gameScene.width
        @pos.x = 0

      # Jump
      if not @jumping and controls.keys['space']
        @velocity.y = -JUMP_VELOCITY
        @jumping = true

      # Drag and GRAVITY
      @velocity.x *= DRAG
      @velocity.y += delta * GRAVITY

      # Update position
      oldY = @pos.y
      @pos.x += delta * @velocity.x
      @pos.y += delta * @velocity.y

      # Check for collisions
      @checkPlatforms oldY

    checkPlatforms: (oldY) ->
      for platform in @gameScene.platformManager.platforms
        if platform.solid() and @pos.y > platform.rect.y and platform.rect.y >= oldY
          if @pos.x > platform.rect.left - PLATFORM_OFFSET and @pos.x < platform.rect.right + PLATFORM_OFFSET
            @pos.y = platform.rect.y
            @velocity.y = 0
            @jumping = false
            platform.collision()

    render: (camera) ->
      # Update UI
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@pos.x}px,#{@pos.y - camera.position}px) scale(#{@flip}, 1)"

  return Player
