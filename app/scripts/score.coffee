define [], ->
  class Score

    constructor: ->
      if not localStorage['topScores']?
        @topScores = []
      else
        @parseScores localStorage['topScores']

    isTopScore: (score) ->
      top = 0
      for storedScore in @topScores
        if storedScore > top
          top = storedScore
      return score > top

    storeScore: (name, score) ->
      if not isTopScore score
        return
      
      @topScores.push {name:name, score:score}
      @topScores.sort (a,b) ->
        a.scare > b.score
      @topScores.splice @topScores.length-1, 1

      @_saveScores()

    _saveScores: ->
      str = JSON.stringify @topScores
      localStorage['topScores'] = str

    parseScores: (string) ->
      @topScores = JSON.parse(string)
      @topScores.sort (a, b) ->
        a.score > b.score

  return new Score
