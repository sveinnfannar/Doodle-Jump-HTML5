define ["item"], (Item) ->
  class Trampoline extends Item
    SCALED = false
    COLLISION_DISTANCE = 20
    FORCE = -2000

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
      e.addClass "trampoline"
      return e

    @property 'center',
      get: ->
        {x:@x + @width / 2, y: @y + @height / 2}

    collision: ->
      super()
      @collected = false
      @gameScene.player.applyForce 0, FORCE
      @gameScene.player.getAnimationEl().addClass "trampoline"
      #@gameScene.sounds.play('spring_sound')

  return Trampoline
