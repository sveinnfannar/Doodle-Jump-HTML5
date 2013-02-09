define ["entity"], (Entity) ->
  class Obstacle extends Entity
    makeElement: ->
      return $('<div class="obstacle">')
    
    checkPlayerCollision: (player, oldPosition) ->
      if player.pos.x > @x - player.width / 4 and player.pos.x < @x + @width + player.width / 4
        if player.pos.y > @y and @y >= oldPosition.y
          @collision()
          @gameScene.player.land @y
        else if player.pos.y - player.height < @y and @y <= oldPosition.y - player.height
          @collision()

    collision: ->
      @gameScene.player.velocity.y = 0

  return Obstacle
