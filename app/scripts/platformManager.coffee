define ["platform"], (Platform) ->
  class PlatformManager
    AVERAGE_PLATFORM_DISTANCE = 30

    constructor: (screenWidth, screenHeight) ->
      @platforms = []
      @screenWidth = screenWidth
      @screenHeight = screenHeight

    reset: ->
      @addRandomPlatforms()

    addRandomPlatforms: ->
      previousX = @screenWidth/2 - 45
      for y in [@screenHeight/AVERAGE_PLATFORM_DISTANCE..0]
        x = (Math.sin(y) * @screenWidth/4 + previousX) + 20 * (Math.random() - 0.5)
        @createPlatform x,
                        Math.random()*20 + y*AVERAGE_PLATFORM_DISTANCE
        previousX = x

    render: (camera) ->
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

      platform = new Platform(rect)
      @platforms.push platform
