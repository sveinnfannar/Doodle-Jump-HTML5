define [], ->
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

    drawAt: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(0px,#{-camera.position}px)"

  return Platform
