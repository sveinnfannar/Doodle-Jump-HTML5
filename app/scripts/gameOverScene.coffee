define ["scene"], (Scene) ->
  class GameOverScene extends Scene
    SCALED = false
    END_TIME = 200
    SCROLL_SPEED = 400

    constructor: (@game, @score) ->
      super @game, "gameOverScene"

      if not SCALED
        END_TIME *= @game.ratio
        SCROLL_SPEED *= @game.ratio
        SCALED = true
      console.log "game over"

    update: (dt) ->
      super dt

  return GameOverScene
