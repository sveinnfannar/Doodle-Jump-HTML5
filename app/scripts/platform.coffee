define [], ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Platform
    PLATFORM_WIDTH = 90 # A small quick-fix because @el.width() returns 0 in the constructor

    constructor: (rect) ->
      @el = $('<div class="platform">')
      @rect = rect
      @rect.right = @rect.x + PLATFORM_WIDTH
      @el.css {
        left: rect.x
        top: rect.y
      }

    @property 'x',
      get: -> @rect.x

    @property 'y',
      get: -> @rect.y

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(0px,#{-camera.position}px)"

  return Platform
