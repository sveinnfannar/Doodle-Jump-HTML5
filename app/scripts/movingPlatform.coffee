define ["platform"], (Platform) ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class MovingPlatform extends Platform
    SCALED = false
    SPEED = 20

    constructor: (gameScene, x, y, xBounds) ->
      super gameScene, x, y
      @minX = xBounds.min
      @maxX = xBounds.max
      if not SCALED
        SPEED *= gameScene.game.ratio
        SCALED = true
      @velocity = SPEED

    update: (dt) ->
      super dt
      @x = @x + @velocity * dt
      
      if @x > @maxX or @x < @minX
        @velocity *= -1

  return MovingPlatform
