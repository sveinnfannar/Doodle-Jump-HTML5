define ["platform", "player", "camera", "platformManager"], (Platform, Player, Camera, PlatformManager)->
  class GameScene
    constructor: (width, height)->
      @player = new Player($('<div class="player">'), this)
      @camera = new Camera(height/2, height)
      @platformManager = new PlatformManager(width, height)

      @width = width
      @height = height

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

    render: ->
      @player.render @camera
      @platformManager.render @camera
      
      # Request next frame.
      



  return GameScene
