define ["scene", "controls"], (Scene, controls) ->
  class MenuScene extends Scene
    constructor: (@game) ->
      super @game, "menuScene"
      @play = $('<div class="button play"><a href="#">Play</a></div>')
      @about = $('<div class="button about"><a href="#">About</a></div>')
      @addChildElement @play
      @addChildElement @about
      @addChildElement($('<div class="doodle"></div>'))
      controls.on('keydown', @clickPlayButton.bind(@))
      @play.on('touchstart', @clickPlayButton.bind(@))
           .on('click', @clickPlayButton.bind(@))

    clickPlayButton: (e) ->
      @game.startGame()
    
    cleanup: ->
      super()
      controls.off('keydown')
      controls.off('touch')

  return MenuScene
