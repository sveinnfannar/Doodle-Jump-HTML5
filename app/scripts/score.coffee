define [], ->
  class Score
    MAX_HISTORY_LENGTH = 10

    constructor: ->
      if not localStorage['topScores']?
        @topScores = []
      else
        @parseScores localStorage['topScores']

    topScore: ->
      console.log @topScores
      top = 0
      if @topScores.length > 0
        top = @topScores.slice(-1)[0] # Last element
      return top

    isTopScore: (score) ->
      return score > @topScore().score

    storeScore: (name, score) ->
      if not @isTopScore score
        return
      
      @topScores.push {name:name, score:score}
      @topScores.sort (a,b) ->
        a.scare < b.score
      if @topScores.len > MAX_HISTORY_LENGTH
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
