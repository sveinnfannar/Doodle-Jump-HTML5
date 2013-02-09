define ["item"], (Item) ->
  class Coin extends Item
    SCALED = false
    COLLISION_DISTANCE = 20

    constructor: (gameScene, rect, @value) ->
      super gameScene, rect
      if not @value?
        @value = 10

      @center = {x:rect.left + @width / 2, y: rect.y + @height/2}
      @el.addClass "coin"
      if not SCALED
        COLLISION_DISTANCE *= gameScene.game.ratio
        COLLISION_DISTANCE *= COLLISION_DISTANCE
        #square the collision distance so we don't need to take sqrt in collision detection
        SCALED = true

    checkPlayerCollision: (player, oldPosition) ->
      playerCenter = {x:player.pos.x, y: player.pos.y - player.PLAYER_SIZE.y/2}
      dist = Math.pow(Math.abs(playerCenter.x - @center.x), 2) + Math.pow(Math.abs(playerCenter.y - @center.y), 2)

      if dist < COLLISION_DISTANCE
        @collision()

    collision: ->
      super()
      @gameScene.scoreBoard.score += @value

  return Coin
