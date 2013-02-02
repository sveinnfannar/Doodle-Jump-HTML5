define ["platform"], (Platform) ->
  class PlatformManager
    constructor: (screenWidth, screenHeight) ->
      @platforms = []
      @screenWidth = screenWidth
      @screenHeight = screenHeight

    reset: ->
      @addRandomPlatforms()

    addRandomPlatforms: ->
      # Create random platforms (this needs to be improved because of overlapping)
      for y in [@screenHeight/10..0]
        @createPlatform Math.random()*(@screenWidth-90), Math.random()*10 + y*10

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
