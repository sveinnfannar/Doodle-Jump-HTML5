define ["platform", "movingPlatform"], (Platform, MovingPlatform) ->
  class PlatformManager
    SCALED = false
    AVERAGE_PLATFORM_DISTANCE = 30
    PLATFORM_SIZE = {x: 45, y: 11}
    HALF_PLATFORM_WIDTH = PLATFORM_SIZE.x / 2
    PLATFORM_X_VARIANCE = 20
    PLATFORM_Y_VARIANCE = 20

    constructor: (@gameScene) ->
      @platforms = []
      @screenWidth = @gameScene.width
      @screenHeight = @gameScene.height
      @previousCameraPosition = NaN
      ratio = @gameScene.game.ratio
      if not SCALED
        AVERAGE_PLATFORM_DISTANCE *= ratio
        PLATFORM_SIZE.x *= ratio
        PLATFORM_SIZE.y *= ratio
        HALF_PLATFORM_WIDTH *= ratio
        PLATFORM_X_VARIANCE *= ratio
        PLATFORM_Y_VARIANCE *= ratio
        SCALED = true
      return

    reset: ->
      @addRandomPlatforms()

    addRandomPlatforms: ->
      previousX = @screenWidth/2 - HALF_PLATFORM_WIDTH
      for y in [@screenHeight/AVERAGE_PLATFORM_DISTANCE..0]
        x = (Math.sin(y) * @screenWidth/4 + previousX) + PLATFORM_X_VARIANCE * (Math.random() - 0.5)
        @createPlatform x,
                        Math.random()*PLATFORM_Y_VARIANCE + y*AVERAGE_PLATFORM_DISTANCE
        previousX = x

    render: (camera) ->
      if camera.position != @previousCameraPosition
        @previousCameraPosition = camera.position
      platform.render camera for platform in @platforms

    update: (dt, camera) ->
      platform.update(dt) for platform in @platforms
      first = @platforms[0]
      while first.y - camera.position > @screenHeight
        first.y -= @screenHeight + 20
        first.x = Math.random() * (@screenWidth + PLATFORM_SIZE.x) - PLATFORM_SIZE.x
        @platforms.shift()

        if Math.random() > 0.5
          console.log "making moving"
          first.el.remove()
          first = new MovingPlatform(@getPlatformRect(first.x, first.y), {min: first.x-50, max: first.x+50})
          @gameScene.game.el.append first.el
        @platforms.push first
        first = @platforms[0]

    createPlatform: (x, y) ->
      rect = @getPlatformRect(x, y)

      platform = new Platform(rect)
      @platforms.push platform
    
    getPlatformRect:(x, y) ->
      rect =
        x: x
        y: y
        right: x + PLATFORM_SIZE.x
        bottom: y + PLATFORM_SIZE.y
