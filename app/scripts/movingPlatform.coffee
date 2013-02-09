define ["platform"], (Platform) ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class MovingPlatform extends Platform
    SCALED = false
    SPEED = 20
    MAX_DISTANCE = 50

    constructor: (gameScene, x, y, xBounds) ->
      super gameScene, x, y
      if not SCALED
        SPEED *= gameScene.game.ratio
        MAX_DISTANCE *= gameScene.game.ratio
        SCALED = true
      @minX = x - MAX_DISTANCE
      @maxX = x + MAX_DISTANCE
      @velocity = SPEED

    update: (dt) ->
      super dt
      @x = @x + @velocity * dt
      
      if @x > @maxX or @x < @minX
        @velocity *= -1

  return MovingPlatform
