define [], ->
  class MenuScene

    constructor: (@game) ->
      @newgame = $('<span class="newGame">New Game</span>')
      width = @game.width / 6
      @newgame.css {
        'left': "#{@game.width / 2 - width*3/2}px",
        'top': "100px",
        'font-size': "#{width}px"
      }
    
    buildScene: ->
      return [@newgame]

    click: (event) ->
      @game.startGame()

    onFrame: (dt) ->
      #nothing

  return MenuScene
