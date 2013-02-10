define ["scene", "scoreBoard", "score"], (Scene, ScoreBoard, score) ->
  class GameOverScene extends Scene
    constructor: (@game, @currentScore) ->
      super @game, "gameOverScene"
      @scoreBoard = new ScoreBoard(@)
      @scoreBoard.score = @currentScore
      @addChildElement(@scoreBoard.el)

      # Create the content in a horrible horrible way
      @informationEl = $('<div class="information">
                          <span class="heading">Game Over!</span>
                          </div>')
      @yourScoreEl = $('<div>Your score: </div>')
      @yourScoreNumEl = $('<span class="yourScore">0</span>')
      @highScoreEl = $('<div>High score: </div>')
      @highScoreNumEl = $('<span class="highScore">0</span>')
      @againButtonEl = $('<div class="button playAgain"><a href="#">Again!</a></div>')

      @yourScoreEl.append @yourScoreNumEl
      @highScoreEl.append @highScoreNumEl
      @informationEl.append @yourScoreEl
      @informationEl.append @highScoreEl
      @addChildElement @againButtonEl
      @addChildElement @informationEl

      # Subscribe to events
      @againButtonEl.on('touchstart', @clickAgainButton.bind(@))
                    .on('click', @clickAgainButton.bind(@))

      # Update the UI
      @yourScoreNumEl.html @currentScore
      @highScoreNumEl.html score.topScore().score

      # Store the score
      score.storeScore "Sveinn", @currentScore

    clickAgainButton: ->
      @game.startGame()

    update: (dt) ->
      super dt

  return GameOverScene
