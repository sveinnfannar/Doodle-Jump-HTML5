define ['score'], (score) ->
  class ScoreBoard

    constructor: (@gameScene) ->
      @el = $('<div class="scoreboard">0</div>')

      return

    update: (camera) ->
      @el.html Math.floor -camera.position

  return ScoreBoard
