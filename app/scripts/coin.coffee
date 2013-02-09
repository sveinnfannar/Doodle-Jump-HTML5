define ["item"], (Item) ->
  class Coin extends Item
    SCALED = false
    COLLISION_DISTANCE = 20
    COIN_SIZE = {width: 15, height: 15}

    constructor: (gameScene, rect, @value) ->
      if not SCALED
        ratio = gameScene.game.ratio
        COLLISION_DISTANCE *= ratio
        COLLISION_DISTANCE *= COLLISION_DISTANCE
        #square the collision distance so we don't need to take sqrt in collision detection
        COIN_SIZE.width *= ratio
        COIN_SIZE.height *= ratio
        SCALED = true
      rect.right = rect.x + COIN_SIZE.width
      rect.bottom = rect.y + COIN_SIZE.height
      super gameScene, rect
      if not @value?
        @value = 10

      @center = {x:rect.left + @width / 2, y: rect.y + @height/2}
      @el.addClass "coin"

    checkPlayerCollision: (player, oldPosition) ->
      playerCenter = {x:player.pos.x, y: player.pos.y - player.PLAYER_SIZE.y/2}
      dist = Math.pow(Math.abs(playerCenter.x - @center.x), 2) + Math.pow(Math.abs(playerCenter.y - @center.y), 2)

      if dist < COLLISION_DISTANCE
        @collision()

    collision: ->
      super()
      @gameScene.scoreBoard.score += @value

  return Coin
