define ["platform"], (Platform) ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class MovingPlatform extends Platform
    SPEED = 20

    constructor: (rect, xBounds) ->
      super rect
      @minX = xBounds.min
      @maxX = xBounds.max
      @velocity = SPEED

    update: (dt) ->
      super dt
      @x = @x + @velocity * dt
      
      if @x > @maxX or @x < @minX
        @velocity *= -1

  return MovingPlatform
