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
      for i in [0..10]
        @createPlatform Math.random()*(@screenWidth-90), Math.random()*(@screenHeight-30)

    render: (camera) ->
      platform.render camera for platform in @platforms

    move: (camera) ->


    createPlatform: (x, y) ->
      rect =
        x: x
        y: y

      platform = new Platform(rect)
      @platforms.push platform
