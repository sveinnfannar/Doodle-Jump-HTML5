define [], ->
  class Score
    MAX_HISTORY_LENGTH = 10

    constructor: ->
      if not localStorage['topScores']?
        @topScores = []
      else
        @parseScores localStorage['topScores']
      console.log @topScores

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
      @topScores.sort()
      @topScores.splice MAX_HISTORY_LENGTH

      @_saveScores()

    _saveScores: ->
      str = JSON.stringify @topScores
      localStorage['topScores'] = str

    parseScores: (string) ->
      @topScores = JSON.parse(string)
      @topScores.sort()

  return new Score
