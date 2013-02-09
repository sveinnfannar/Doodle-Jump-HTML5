define ["scene", "controls"], (Scene, controls) ->
  class MenuScene extends Scene
    constructor: (@game) ->
      super @game, "menuScene"
      @addChildElement($('<div class="button play">Play</div>
                          <div class="button about">About</div>
                          <div class="doodle"></div>'))
      controls.on('keydown', @clickPlayButton.bind(@))
      controls.on('touch', @clickPlayButton.bind(@))

    clickPlayButton: (e) ->
      @game.startGame()
    
    cleanup: ->
      super()
      controls.off('keydown')
      controls.off('touch')

  return MenuScene
