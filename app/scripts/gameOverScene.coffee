define ["scene", "scoreBoard"], (Scene, ScoreBoard) ->
  class GameOverScene extends Scene
    constructor: (@game, @score) ->
      super @game, "gameOverScene"
      @scoreBoard = new ScoreBoard(@)
      @scoreBoard.score = @score
      @addChildElement(@scoreBoard.el)
      @addChildElement $('<span class="heading"></span>')

    update: (dt) ->
      super dt

  return GameOverScene
