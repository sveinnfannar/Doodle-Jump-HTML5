define ["item"], (Item) ->
  class Coin extends Item
    SCALED = false
    COLLISION_DISTANCE = 20
    DEFAULT_VALUE = 10

    constructor: (gameScene, x, y, @value) ->
      super gameScene, x, y
      if not @value?
        @value = DEFAULT_VALUE

      if not SCALED
        ratio = gameScene.game.ratio
        COLLISION_DISTANCE *= ratio
        COLLISION_DISTANCE *= COLLISION_DISTANCE
        #square the collision distance so we don't need to take sqrt in collision detection
        SCALED = true

    makeElement: ->
      e = super()
      e.addClass "coin"
      return e

    @property 'center',
      get: ->
        {x:@x + @width / 2, y: @y + @height / 2}

    checkPlayerCollision: (player, oldPosition) ->
      playerCenter = {x:player.pos.x, y: player.pos.y - player.height/2}
      dist = Math.pow(Math.abs(playerCenter.x - @center.x), 2) + Math.pow(Math.abs(playerCenter.y - @center.y), 2)

      if dist < COLLISION_DISTANCE
        @collision()

    collision: ->
      super()
      @gameScene.scoreBoard.score += @value
      @gameScene.sounds.play('coin')

  return Coin
