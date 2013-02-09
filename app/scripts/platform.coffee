define ["entity"], (Entity) ->
  class Platform extends Entity

    makeElement: ->
      return $('<div class="platform">')

    collision: ->
      super()
      @gameScene.player.land @rect.y

  return Platform
