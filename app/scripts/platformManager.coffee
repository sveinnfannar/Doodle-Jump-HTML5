define ["platform"], (Platform) ->
  class PlatformManager
    AVERAGE_PLATFORM_DISTANCE = 30
    PLATFORMS_ON_SCREEN = 15

    constructor: (screenWidth, screenHeight) ->
      @platforms = []
      @screenWidth = screenWidth
      @screenHeight = screenHeight
      @previousCameraPosition = NaN
      @lastCreatedPlatformPosition = {x: @screenWidth/2, y:@screenHeight}

    reset: ->
      @addRandomPlatforms()

    addRandomPlatforms: ->
      for i in [0..PLATFORMS_ON_SCREEN]
        x = @lastCreatedPlatformPosition.x
        offset = (if Math.random() < 0.5 then -1 else 1) * (50 + Math.random() * 50)
        if x + offset < 45 #or x + offset > @screenWidth - 45
          offset *= -1
        x += offset
        @createPlatform @lastCreatedPlatformPosition.x + (if Math.random() < 0.5 then -1 else 1) * (50 + Math.random() * 50),
                        @lastCreatedPlatformPosition.y - (@screenHeight/PLATFORMS_ON_SCREEN)

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
      position =
        x: x
        y: y

      platform = new Platform(position)
      @platforms.push platform
      @lastCreatedPlatformPosition  = position