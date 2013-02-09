define ["platform", "movingPlatform", "fragilePlatform", "coin"], (Platform, MovingPlatform, FragilePlatform, Coin) ->
  class EntityManager
    SCALED = false
    AVERAGE_PLATFORM_DISTANCE = 30
    PLATFORM_SIZE = {x: 45, y: 11}
    HALF_PLATFORM_WIDTH = PLATFORM_SIZE.x / 2
    PLATFORM_X_VARIANCE = 20
    PLATFORM_Y_VARIANCE = 20

    constructor: (@gameScene) ->
      @entities = []
      @platforms = []
      @items = []
      @enemies = []
      @obstacles = []
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
      entity.render camera for entity in @entities

    update: (dt, camera) ->
      entity.update(dt) for entity in @entities
      @updatePlatforms(camera)
      @updateEnemies(camera)
      @updateItems(camera)
      @updateObstacles(camera)

    _shouldRemove: (entity, camera) ->
      return entity.y - camera.position > @screenHeight or entity.dead()

    updatePlatforms: (camera) ->
      remove = (platform for platform in @platforms when @_shouldRemove platform, camera)
      for platform in remove
        platform.y -= @screenHeight + 20
        platform.x = Math.random() * (@screenWidth + PLATFORM_SIZE.x) - PLATFORM_SIZE.x
        @platforms.splice @platforms.indexOf(platform), 1
        @entities.splice @entities.indexOf(platform), 1
        r = Math.random()

        platform.el.remove()
        if r > 0.6
          platform = new MovingPlatform @gameScene, @getRect(platform.x, platform.y), {min: platform.x-50, max: platform.x+50}
        else if r > 0.3
          platform = new FragilePlatform @gameScene, @getRect(platform.x, platform.y)
          if Math.random() > 0.6
            r = @getRect(platform.x, platform.y - 20)
            r.right -= 20
            r.x += 20
            coin = new Coin @gameScene, r
            @gameScene.game.el.append coin.el
            @items.push coin
            @entities.push coin
        else
          platform = new Platform @gameScene, @getRect(platform.x, platform.y)
        @gameScene.game.el.append platform.el
        @platforms.push platform
        @entities.push platform

    updateEnemies: (camera) ->
      remove = (enemy for enemy in @enemies when @_shouldRemove enemy, camera)
      for enemy in remove
        @enemies.splice @enemies.indexOf(enemy), 1
        @entities.splice @entities.indexOf(enemy), 1

        enemy.el.remove()

    updateItems: (camera) ->
      remove = (item for item in @items when @_shouldRemove item, camera)
      for item in remove
        @items.splice @items.indexOf(item), 1
        @entities.splice @entities.indexOf(item), 1

        item.el.remove()

    updateObstacles: (camera) ->
      remove = (obstacle for obstacle in @obstacles when @_shouldRemove obstacle, camera)
      for obstacle in remove
        @obstacles.splice @obstacles.indexOf(obstacle), 1
        @entities.splice @entities.indexOf(obstacle), 1

        obstacle.el.remove()

    createPlatform: (x, y) ->
      rect = @getRect(x, y)
      platform = new Platform @gameScene, rect
      @platforms.push platform
      @entities.push platform
    
    getRect:(x, y) ->
      rect =
        x: x
        y: y
        right: x + PLATFORM_SIZE.x
        bottom: y + PLATFORM_SIZE.y

  return EntityManager
