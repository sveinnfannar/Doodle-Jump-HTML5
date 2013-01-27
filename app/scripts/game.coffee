#global define, $ 
define ["player", "platform"], (Player, Platform) ->
  
  ###
  Main game class.
  @param {Element} el DOM element containig the game.
  @constructor
  ###
  Game = (el) ->
    @el = el
    @player = new Player(@el.find(".player"), this)

    # Cache a bound onFrame, el.width() and el.height() since we need them each frame.
    @onFrame = @onFrame.bind(this)
    @width = el.width()
    @height = el.height()

  Game::reset = ->
    @player.pos = 
      x: @width/2
      y: 550
    @platforms = []
    @addRandomPlatforms()

  Game::createPlatform = (x, y) ->
    rect =
      x: x
      y: y

    platform = new Platform(rect)
    @platforms.push platform
    @el.append platform.el

  Game::addRandomPlatforms = ->
    # Create one platform under him
    @createPlatform(@width/2 - 45, @height - 30)

    # Create random platforms (this needs to be improved because of overlapping)
    for i in [0..10]
      @createPlatform Math.random()*(@width-90), Math.random()*(@height-30)
  
  ###
  Runs every frame. Calculates a delta and allows each game entity to update itself.
  ###
  Game::onFrame = ->
    now = +new Date() / 1000
    delta = now - @lastFrame
    @lastFrame = now
    @player.onFrame delta
    @player.checkPlatforms @platforms
    
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
