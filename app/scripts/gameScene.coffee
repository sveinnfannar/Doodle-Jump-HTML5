define ["player", "camera", "platformManager", "gameOverScene"], (Player, Camera, PlatformManager, GameOverScene)->
  class GameScene
    constructor: (@game)->
      @player = new Player($('<div class="player">'), this)
      @camera = new Camera(@game.height/2, @game.height)
      @platformManager = new PlatformManager(@game.width, @game.height)
      @width = @game.width
      @height = @game.height
      @reset()

    buildScene: ->
      return [@player.el].concat (platform.el for platform in @platformManager.platforms)

    reset: ->
      @player.pos =
        x: @width/2
        y: 550
      @platformManager.createPlatform(@width/2 - 45, @height - 30)
      @platformManager.reset()

    onFrame: (dt) ->
      @update dt
      @render()

    update: (dt) ->
      @player.update dt
      @camera.update dt, @player
      @platformManager.update @camera
      if @player.pos.y > @camera.position + @game.height
        @game.switchScene(new GameOverScene(@game, this))

    render: ->
      @player.render @camera
      @platformManager.render @camera
      # Move background
      @game.el.css "background-position", "0px #{-@camera.position*0.4}px"

  return GameScene
