define [], ->
  class Score
    MAX_HISTORY_LENGTH = 10

    constructor: ->
      if not localStorage['topScores']?
        @topScores = []
      else
        @parseScores localStorage['topScores']

    topScore: ->
      top = {name: 'noone', score: 0}
      if @topScores.length > 0
        top = @topScores[0] # First element
      return top

    isTopScore: (score) ->
      return score > @topScore().score

    storeScore: (name, score) ->
      if not @isTopScore score
        return
      
      @topScores.splice 0, 0, {name:name, score:score}
      @topScores.sort (a,b) ->
        a.scare < b.score
      while @topScores.len > MAX_HISTORY_LENGTH
        @topScores.splice @topScores.length-1, 1

      @_saveScores()

    _saveScores: ->
      str = JSON.stringify @topScores
      localStorage['topScores'] = str

    parseScores: (string) ->
      @topScores = JSON.parse(string)
      @topScores.sort (a, b) ->
        a.score < b.score

  return new Score
