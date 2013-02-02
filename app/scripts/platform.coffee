define [], ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Platform
    constructor: (rect) ->
      @PLATFORM_WIDTH = 90 # A small quick-fix because @el.width() returns 0 in the constructor
      @el = $('<div class="platform">')
      @rect = rect
      @rect.right = @rect.x + @PLATFORM_WIDTH/2
      @rect.left = @rect.x - @PLATFORM_WIDTH/2
      console.log @rect
      @el.css {
        left: rect.left
      }

    @property 'x',
      get: -> @rect.x

    @property 'y',
      get: -> @rect.y
      set: (y) -> @rect.y = y

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(0px,#{@rect.y-camera.position}px)"

  return Platform
