#global define, $ 
define ["player", "platform", "camera", "platformManager"], (Player, Platform, Camera, PlatformManager) ->
  
  ###
  Main game class.
  @param {Element} el DOM element containig the game.
  @constructor
  ###
  Game = (el) ->
    @el = el
    @width = el.width()
    @height = el.height()
    @player = new Player(@el.find(".player"), this)
    @platformManager = new PlatformManager(@el, @width, @height)
    @camera = new Camera(300, 600)

    # Cache a bound onFrame, el.width() and el.height() since we need them each frame.
    @onFrame = @onFrame.bind(this)
    return

  Game::reset = ->
    @player.pos =
      x: @width/2
      y: 550

    # Create one platform under him
    @platformManager.createPlatform(@width/2 - 45, @height - 30)
    @platformManager.reset()
  
  ###
  Runs every frame. Calculates a delta and allows each game entity to update itself.
  ###
  Game::onFrame = ->
    now = +new Date() / 1000
    delta = now - @lastFrame
    @lastFrame = now
    @player.onFrame delta
    @player.checkPlatforms @platforms
    @camera.update delta, @player

    @player.drawAt @camera
    @platformManager.drawAt @camera
    
    # Request next frame.
    requestAnimFrame @onFrame
  
  ###
  Starts the game.
  ###
  Game::start = ->
    # Restart the onFrame loop
    @lastFrame = +new Date() / 1000
    requestAnimFrame @onFrame

    @reset()
  
  ###
  Cross browser RequestAnimationFrame
  ###
  requestAnimFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) -> # function
      window.setTimeout callback, 1000 / 60
  )()
  Game
