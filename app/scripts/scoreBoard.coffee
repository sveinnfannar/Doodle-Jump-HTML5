define ['score'], (score) ->
  class ScoreBoard

    constructor: (@gameScene) ->
      @el = $('<div class="scoreboard">0</div>')
      @score = 0
      return

    update: (camera) ->
      @el.html @score + Math.floor -camera.position

  return ScoreBoard
