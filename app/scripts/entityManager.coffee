define ["platform", "movingPlatform", "fragilePlatform", "coin", "obstacle"], (Platform, MovingPlatform, FragilePlatform, Coin, Obstacle) ->
  class EntityManager
    SCALED = false
    AVERAGE_PLATFORM_DISTANCE = 30
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
        PLATFORM_X_VARIANCE *= ratio
        PLATFORM_Y_VARIANCE *= ratio
        SCALED = true

      return

    reset: ->
      @addRandomPlatforms()

    addRandomPlatforms: ->
      previousX = @screenWidth/2
      for y in [@screenHeight/AVERAGE_PLATFORM_DISTANCE..0]
        x = (Math.sin(y) * @screenWidth/4 + previousX) + PLATFORM_X_VARIANCE * (Math.random() - 0.5)
        @createPlatform x,
                        Math.random()*PLATFORM_Y_VARIANCE + y*AVERAGE_PLATFORM_DISTANCE
        previousX = x
        if Math.random() > 0.8
          obstacle = new Obstacle @gameScene, Math.random() * 300, Math.random() * 600
          @gameScene.game.el.append obstacle.el
          @obstacles.push obstacle
          @entities.push obstacle

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
        platform.x = Math.random() * (@screenWidth + platform.width) - platform.width 
        @platforms.splice @platforms.indexOf(platform), 1
        @entities.splice @entities.indexOf(platform), 1
        r = Math.random()

        if r > 0.8
          newPlatform = new MovingPlatform @gameScene, platform.x, platform.y, {min: platform.x-50, max: platform.x+50}
        else if r > 0.6
          newPlatform = new FragilePlatform @gameScene, platform.x, platform.y
          if Math.random() > 0.6
            coin = new Coin @gameScene, platform.x + platform.width / 2, platform.y
            @gameScene.game.el.append coin.el
            #do this afterwards since height is calculated when added to the dom
            coin.x -= coin.width/2
            coin.y -= coin.height*2
            @items.push coin
            @entities.push coin
        else
          newPlatform = new Platform @gameScene, platform.x, platform.y
        platform.el.remove()
        @gameScene.game.el.append newPlatform.el
        @platforms.push newPlatform
        @entities.push newPlatform

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
      platform = new Platform @gameScene, x, y
      @platforms.push platform
      @entities.push platform

  return EntityManager
