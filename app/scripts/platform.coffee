define [], ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Platform

    constructor: (rect) ->
      @el = $('<div class="platform">')
      @rect = rect
      @width = rect.right - rect.x
      @height = rect.bottom - rect.y
      @el.css {
        width: @width
        height: @height
      }

    @property 'x',
      get: -> @rect.x
      set: (x) ->
        @rect.x = x
        @rect.right = x + @width

    @property 'y',
      get: -> @rect.y
      set: (y) -> @rect.y = y

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@rect.x}px,#{@rect.y-camera.position}px)"

  return Platform
