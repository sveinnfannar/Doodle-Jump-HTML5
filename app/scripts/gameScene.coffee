define ["player", "camera", "entityManager", "gameOverScene", "scoreBoard"], (Player, Camera, EntityManager, GameOverScene, ScoreBoard)->
  class GameScene
    constructor: (@game)->
      @width = @game.width
      @height = @game.height
      @player = new Player(this)
      @camera = new Camera(@game.height/2, @game.height)
      @entityManager = new EntityManager(this)
      @scoreBoard = new ScoreBoard(@)
      @reset()

    buildScene: ->
      return [@player.el, @scoreBoard.el].concat (platform.el for platform in @entityManager.platforms)

    reset: ->
      @player.pos =
        x: @width/2
        y: (5.5 * @height) / 6
      @entityManager.createPlatform(@width/2, @height - 30)
      @entityManager.reset()

    onFrame: (dt) ->
      @update dt
      @render()

    click: (event) ->
      console.log "hi from gamescene"

    update: (dt) ->
      @player.update dt
      @camera.update dt, @player
      @entityManager.update dt, @camera
      @scoreBoard.update @camera
      if @player.pos.y > @camera.position + @game.height
        @game.switchScene(new GameOverScene(@game, this))

    render: ->
      @player.render @camera
      @entityManager.render @camera
      # Move background
      @game.el.css "background-position", "0px #{-@camera.position*0.4}px"

  return GameScene
