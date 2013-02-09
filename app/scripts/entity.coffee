define [], ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Entity

    constructor: (rect) ->
      @el = @makeElement()
      @rect = rect
      @rect.left = @rect.x
      @width = rect.right - rect.x
      @height = rect.bottom - rect.y
      @el.css {
        width: @width
        height: @height
      }

    @makeElement: ->
      alert "makeElement called in superclass"

    @property 'x',
      get: -> @rect.x
      set: (x) ->
        @rect.x = x
        @rect.right = x + @width
        @rect.left = x

    @property 'y',
      get: -> @rect.y
      set: (y) ->
        @rect.y = y
        @rect.bottom = y + @height

    update: (dt) ->
      #do nothing

    collision: () ->
      #do nothing

    dead: () ->
      return false

    solid: ->
      return true

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@rect.x}px,#{@rect.y-camera.position}px)"

  return Entity
