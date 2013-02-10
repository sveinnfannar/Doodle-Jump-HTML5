define ["item"], (Item) ->
  class Jetpack extends Item
    SCALED = false
    COLLISION_DISTANCE = 20
    FORCE = -1800
    TIME = 1

    constructor: (gameScene, x, y) ->
      super gameScene, x, y

      if not SCALED
        ratio = gameScene.game.ratio
        FORCE *= ratio
        COLLISION_DISTANCE *= ratio
        COLLISION_DISTANCE *= COLLISION_DISTANCE
        #square the collision distance so we don't need to take sqrt in collision detection
        SCALED = true

    makeElement: ->
      e = super()
      e.addClass "jetpack"
      return e

    @property 'center',
      get: ->
        {x:@x + @width / 2, y: @y + @height / 2}

    collision: ->
      super()
      @gameScene.player.startJetpack FORCE, TIME

  return Jetpack
