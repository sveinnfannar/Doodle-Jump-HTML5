define ["platform", "movingPlatform", "fragilePlatform"], (Platform, MovingPlatform, FragilePlatform) ->
  class EntityManager
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
      remove = (platform for platform in @platforms when platform.y - camera.position > @screenHeight or platform.dead())
      for platform in remove
        platform.y -= @screenHeight + 20
        platform.x = Math.random() * (@screenWidth + PLATFORM_SIZE.x) - PLATFORM_SIZE.x
        @platforms.splice @platforms.indexOf(platform), 1
        r = Math.random()

        platform.el.remove()
        if r > 0.6
          platform = new MovingPlatform @getPlatformRect(platform.x, platform.y), {min: platform.x-50, max: platform.x+50}
        else if r > 0.3
          platform = new FragilePlatform @getPlatformRect(platform.x, platform.y)
        else
          platform = new Platform @getPlatformRect(platform.x, platform.y)
        @gameScene.game.el.append platform.el
        @platforms.push platform

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

  return EntityManager
