define ["controls"], (controls) ->
  class MenuScene
    SIZE = {width:396, height:600}

    constructor: (@game) ->
      @el = $('<div class="menuScene">
                <div class="button play">Play</div>
                <div class="button about">About</div>
                <div class="doodle"></div>
                </div>')
      @playButtonEl = $('button play')
      ratio = game.ratio
      @el.width ratio*SIZE.width
      @el.height ratio*SIZE.height
      controls.on('keydown', @clickPlayButton.bind(@))
      controls.on('touch', @clickPlayButton.bind(@))

    buildScene: ->
      return [@el]

    clickPlayButton: (e) ->
      console.log event
      @playButtonEl.addClass "pressed"
      @game.startGame()

    onFrame: (dt) ->
      # Nothing
    
    cleanup: ->
      controls.off('keydown')
      controls.off('touch')

  return MenuScene
