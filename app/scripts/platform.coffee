define [], ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Platform

    constructor: (rect) ->
      @el = $('<div class="platform">')
      @rect = rect
      @el.css {
        left: rect.x
        width: rect.right - rect.x
      }

    @property 'x',
      get: -> @rect.x

    @property 'y',
      get: -> @rect.y
      set: (y) -> @rect.y = y

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(0px,#{@rect.y-camera.position}px)"

  return Platform
