define ['score'], (score) ->
  class ScoreBoard

    constructor: (@gameScene) ->
      @el = $('<div class="scoreboard">0</div>')
      @_score = 0
      return

    update: (camera) ->
      @score = Math.max(Math.floor(-(@gameScene.player.pos.y - @gameScene.height)), @_score)

    @property 'score',
      get: -> return @_score
      set: (score) ->
        @_score = score
        @el.html score

  return ScoreBoard
