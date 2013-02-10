define ["scene", "scoreBoard", "score"], (Scene, ScoreBoard, score) ->
  class GameOverScene extends Scene
    constructor: (@game, @currentScore) ->
      super @game, "gameOverScene"
      @scoreBoard = new ScoreBoard(@)
      @scoreBoard.score = @currentScore
      @addChildElement(@scoreBoard.el)
      @addChildElement $('<div class="information">
                          <span class="heading">Game Over!</span>
                          <div>Your score: <span class="yourScore">0</span></div>
                          <div>High score: <span class="highScore">0</span></div></div>
                          <div class="button playAgain">Again!</div>')
      @yourScoreEl = $('.yourScore')
      @highScoreEl = $('.highScore')

      @yourScoreEl.html @currentScore
      @highScoreEl.html score.topScore()

    update: (dt) ->
      super dt

  return GameOverScene
