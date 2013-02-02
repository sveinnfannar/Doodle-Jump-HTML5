define ["platform"], (Platform) ->
  class PlatformManager
    AVERAGE_PLATFORM_DISTANCE = 40
    PLATFORM_WIDTH = 90 # A small quick-fix because @el.width() returns 0 in the constructor
    HALF_PLATFORM_WIDTH = 45
    PLATFORM_X_VARIANCE = 20
    PLATFORM_Y_VARIANCE = 20

    constructor: (@gameScene) ->
      @platforms = []
      @screenWidth = @gameScene.width
      @screenHeight = @gameScene.height
      @previousCameraPosition = NaN
      ratio = @gameScene.game.ratio
      AVERAGE_PLATFORM_DISTANCE *= ratio.y
      PLATFORM_WIDTH *= ratio.x
      HALF_PLATFORM_WIDTH *= ratio.x
      PLATFORM_X_VARIANCE *= ratio.x
      PLATFORM_Y_VARIANCE *= ratio.y
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
        first.y -= @screenHeight
        @platforms.shift()
        @platforms.push first
        first = @platforms[0]

    createPlatform: (x, y) ->
      rect =
        x: x
        y: y
        right: x + PLATFORM_WIDTH

      platform = new Platform(rect)
      @platforms.push platform
