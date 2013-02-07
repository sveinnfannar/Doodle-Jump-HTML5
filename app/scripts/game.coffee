#global define, $ 
define ["camera", "gameScene", "controls"], (Camera, GameScene, controls) ->
  
  ###
  Main game class.
  @param {Element} el DOM element containig the game.
  @constructor
  ###
  Game = (el) ->
    @el = el
    @width = el.width()
    @height = window.innerHeight #el.height()
    @DESIGN_SIZE = {x: 550, y: 600}

    @ratio = @height / @DESIGN_SIZE.y
    el.width(@DESIGN_SIZE.x * @ratio)
    @width = el.width()
    console.log @width, @height, @DESIGN_SIZE, @ratio

    # Cache a bound onFrame, el.width() and el.height() since we need them each frame.
    @onFrame = @onFrame.bind(this)
    @active = false
    @currentScene = null
    controls.on('touch', @onTouch.bind(@))
    return

  Game::onTouch = (e) ->
    if @currentScene? and @currentScene.click? and @clickedElement(e, @el)
      @currentScene.click(event)
  
  Game::clickedElement = (event, element) ->
    return event.x < element.width()

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
    @startGame()

  Game::startGame = ->
    @switchScene(new GameScene(this))
  
  ###
  Cross browser RequestAnimationFrame
  ###
  requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) -> # function
      window.setTimeout callback, 1000 / 60
  )()
  Game
