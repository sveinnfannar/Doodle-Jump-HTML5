define [], ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class Entity

    constructor: (@gameScene, rect) ->
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

    #Checks collision with player, defaults to platform detection
    checkPlayerCollision: (player, oldPosition) ->
      if player.pos.y > @rect.y and @rect.y >= oldPosition.y
        if player.pos.x > @rect.left - player.PLAYER_SIZE.x / 4 and player.pos.x < @rect.right + player.PLAYER_SIZE.x / 4
          @collision()

    collision: () ->
      #do nothing

    dead: () ->
      return false

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate(#{@rect.x}px,#{@rect.y-camera.position}px)"

  return Entity
