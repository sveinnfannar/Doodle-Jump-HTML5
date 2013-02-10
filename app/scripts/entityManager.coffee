define ["platform", "movingPlatform", "fragilePlatform", "coin", "obstacle", "trampoline", "jetpack"],
(Platform, MovingPlatform, FragilePlatform, Coin, Obstacle, Trampoline, Jetpack) ->
  class EntityManager
    SCALED = false
    AVERAGE_PLATFORM_DISTANCE = 30
    PLATFORM_X_VARIANCE = 20
    PLATFORM_Y_VARIANCE = 20
    NEW_ENTITY_OFFSET = 20
    NEW_OBSTACLE_CHANCE = 0.03
    NEW_ITEM_CHANCE = 0.05
    NEW_PLATFORM_DISTANCE = 500
    PLATFORM_TYPES = [Platform, MovingPlatform, FragilePlatform]
    ITEM_TYPES = [Coin, Trampoline, Jetpack]
    OBSTACLE_TYPES = [Obstacle]

    constructor: (@gameScene) ->
      @el = $('<div class="entityManager"></div>')
      @entities = []
      @platforms = []
      @items = []
      @enemies = []
      @obstacles = []
      @screenWidth = @gameScene.width
      @screenHeight = @gameScene.height
      @previousCameraPosition = NaN
      @itemTarget = null
      @highestIndex = 1
      @lastNewPlatformType = 0
      ratio = @gameScene.game.ratio
      if not SCALED
        AVERAGE_PLATFORM_DISTANCE *= ratio
        PLATFORM_X_VARIANCE *= ratio
        PLATFORM_Y_VARIANCE *= ratio
        NEW_ENTITY_OFFSET *= ratio
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

    render: (camera) ->
      entity.render camera for entity in @entities
      if camera.position != @previousCameraPosition
        @previousCameraPosition = camera.position
        if Math.random() < NEW_ITEM_CHANCE
          @addRandomItem camera
        if Math.random() < NEW_OBSTACLE_CHANCE
          @addRandomObstacle camera

    addRandomPlatform: (x, y, camera) ->
      type = PLATFORM_TYPES[@_randomIndex @highestIndex]
      newPlatform = new type @gameScene, x, y
      @gameScene.game.el.append newPlatform.el

      @platforms.push newPlatform
      @entities.push newPlatform

      #So we can place an item on top of the newest (topmost) platform if necessary
      @itemTarget = newPlatform

    addRandomObstacle: (camera) ->
      type = OBSTACLE_TYPES[@_randomIndex OBSTACLE_TYPES.length]
      newObstacle = new type @gameScene, 0, camera.position - NEW_ENTITY_OFFSET
      @gameScene.game.el.append newObstacle.el
      newObstacle.x = @_randomEntityXPosition(newObstacle.width)
      @obstacles.push newObstacle
      @entities.push newObstacle

    addRandomItem: (camera) ->
      if not @itemTarget? or @itemTarget instanceof MovingPlatform
        return
      type = ITEM_TYPES[@_randomIndex ITEM_TYPES.length]
      
      newItem = new type @gameScene, 0, 0
      @gameScene.game.el.append newItem.el
      #Need to do this afgter element is added to the DOM to get the width and height
      newItem.x = @itemTarget.x + @itemTarget.width/2 - newItem.width / 2
      newItem.y = @itemTarget.y - @itemTarget.height * 2

      @items.push newItem
      @entities.push newItem
      @itemTarget = null

    _randomIndex: (max) ->
      Math.floor(Math.random() * max)

    _randomEntityXPosition: (width) ->
      Math.random() * (@screenWidth + width) - width
          
    update: (dt, camera) ->
      entity.update(dt) for entity in @entities
      @updatePlatforms camera
      @updateEnemies camera
      @updateItems camera
      @updateObstacles camera
      if @highestIndex < PLATFORM_TYPES.length and @lastNewPlatformType - camera.position > NEW_PLATFORM_DISTANCE
        #This allows us to add new platform types as the game progresses
        @highestIndex += 1
        @lastNewPlatformType = camera.position

    _shouldRemove: (entity, camera) ->
      return entity.y - camera.position > @screenHeight or entity.dead()

    updatePlatforms: (camera) ->
      remove = (platform for platform in @platforms when @_shouldRemove platform, camera)
      for platform in remove
        platform.y -= @screenHeight + NEW_ENTITY_OFFSET
        platform.x = @_randomEntityXPosition platform.width
        @platforms.splice @platforms.indexOf(platform), 1
        @entities.splice @entities.indexOf(platform), 1

        @addRandomPlatform platform.x, platform.y, camera
        platform.el.remove()

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
      @_addEntity platform

    _addEntity: (entity) ->
      @entities.push entity
      @el.append entity.el

  return EntityManager
