define ["platform"], (Platform) ->
  class PlatformManager
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
      AVERAGE_PLATFORM_DISTANCE *= ratio
      PLATFORM_SIZE.x *= ratio
      PLATFORM_SIZE.y *= ratio
      HALF_PLATFORM_WIDTH *= ratio
      PLATFORM_X_VARIANCE *= ratio
      PLATFORM_Y_VARIANCE *= ratio
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

    update: (camera) ->
      first = @platforms[0]
      while first.y - camera.position > @screenHeight
        first.y -= @screenHeight + 20
        first.x = Math.random() * (@screenWidth + PLATFORM_SIZE.x) - PLATFORM_SIZE.x
        @platforms.shift()
        @platforms.push first
        first = @platforms[0]

    createPlatform: (x, y) ->
      rect =
        x: x
        y: y
        right: x + PLATFORM_SIZE.x
        bottom: y + PLATFORM_SIZE.y

      platform = new Platform(rect)
      @platforms.push platform
