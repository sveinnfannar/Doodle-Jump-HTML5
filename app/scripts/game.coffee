#global define, $ 
define ["camera", "gameScene", "controls", "menuScene"], (Camera, GameScene, controls, MenuScene) ->
  class Game
    constructor: (el) ->
      console.log "GAME!!"
      @el = el
      @width = el.width()
      @height = window.innerHeight #el.height()
      @DESIGN_SIZE = {x: 550, y: 600}

      @ratio = @height / @DESIGN_SIZE.y
      el.width(@DESIGN_SIZE.x * @ratio)
      @width = el.width()
      @onFrame = @onFrame.bind(this)
      @active = false
      @currentScene = null
      return

    switchScene: (scene) ->
      @active = false
      @el.empty()
      (@el.append obj for obj in scene.buildScene())
      if @currentScene?
        @currentScene.cleanup()
      @currentScene = scene
      @active = true
    
    onFrame: ->
      if @active
        now = +new Date() / 1000
        delta = now - @lastFrame
        controls.onFrame delta
        @lastFrame = now
        @currentScene.onFrame delta
      
      # Request next frame.
      requestAnimFrame @onFrame.bind(@)
    
    scheduleOnFrame: ->
      @lastFrame = +new Date() / 1000
      requestAnimFrame @onFrame

    startMenu: ->
      @switchScene(new MenuScene(this))

    startGame: ->
      @switchScene(new GameScene(this))
    
    requestAnimFrame = (callback) ->
      if window.requestAnimationFrame or
          window.webkitRequestAnimationFrame or
          window.mozRequestAnimationFrame or
          window.oRequestAnimationFrame or
          window.msRequestAnimationFrame or
          (callback)
        window.setTimeout callback, 1000 / 60
    
  return Game
