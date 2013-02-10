define [], ->

  class Entity

    constructor: (@gameScene, @x, @y) ->
      @el = @makeElement()

    @makeElement: ->
      console.log "makeElement called in superclass"

    @property 'width',
      get: ->
        if @_width?
          return @_width
        @_width = @el.width()

    @property 'height',
      get: ->
        if @_height?
          return @_height
        @_height = @el.height()

    update: (dt) ->
      #do nothing

    #Checks collision with player, defaults to platform detection
    checkPlayerCollision: (player, oldPosition) ->
      if player.pos.y > @y and @y >= oldPosition.y
        if player.pos.x > @x - player.width / 4 and player.pos.x < @x + @width + player.width / 4
          @collision()

    collision: () ->
      #do nothing

    dead: () ->
      return false

    render: (camera) ->
      @el.css $.fx.cssPrefix + 'transform', "translate3d(#{@x}px,#{@y-camera.position}px, 0px)"

  return Entity
