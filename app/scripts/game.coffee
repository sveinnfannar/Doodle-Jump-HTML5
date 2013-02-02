#global define, $ 
define ["player", "platform", "camera", "gameScene", "controls"], (Player, Platform, Camera, GameScene, controls) ->
  
  ###
  Main game class.
  @param {Element} el DOM element containig the game.
  @constructor
  ###
  Game = (el) ->
    @el = el
    @width = el.width()
    @height = el.height()
    @DESIGN_SIZE = {x: 532, y: 600}
    @ratio = {x: @width / @DESIGN_SIZE.x, y: @height / @DESIGN_SIZE.y}

    # Cache a bound onFrame, el.width() and el.height() since we need them each frame.
    @onFrame = @onFrame.bind(this)
    @active = false
    @currentScene = null
    return


  Game::switchScene = (scene) ->
    @active = false
    @el.empty()
    (@el.append obj for obj in scene.buildScene())
    @currentScene = scene
    @active = true
  
  ###
  Runs every frame. Calculates a delta and allows each game entity to update itself.
  ###
  Game::onFrame = ->
    if @active
      now = +new Date() / 1000
      delta = now - @lastFrame
      controls.onFrame delta
      @lastFrame = now
      @currentScene.onFrame delta
    
    # Request next frame.
    requestAnimFrame @onFrame
  
  ###
  Starts the game.
  ###
  Game::start = ->
    # Restart the onFrame loop
    @lastFrame = +new Date() / 1000
    requestAnimFrame @onFrame

    @switchScene(new GameScene(this))
  
  ###
  Cross browser RequestAnimationFrame
  ###
  requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) -> # function
      window.setTimeout callback, 1000 / 60
  )()
  Game
