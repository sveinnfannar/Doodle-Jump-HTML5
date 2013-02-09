define ["controls"], (controls) ->
  class MenuScene
    SIZE = {width:396, height:600}

    constructor: (@game) ->
      @el = $('<div class="menuScene">
                <div class="button">Play</div>
                <div class="button">About</div>
                </div>')
      ratio = game.ratio
      console.log ratio
      @el.width ratio*SIZE.width
      @el.height ratio*SIZE.height
      controls.on('touch', @onTouch.bind(@))

    buildScene: ->
      return [@el]

    onTouch: (event) ->
      @game.startGame()

    onFrame: (dt) ->
      #nothing
    
    cleanup: ->
      controls.off('touch')

  return MenuScene
