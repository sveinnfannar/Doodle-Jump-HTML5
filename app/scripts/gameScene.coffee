define ["scene", "player", "camera", "entityManager", "scoreBoard"],
(Scene, Player, Camera, EntityManager, ScoreBoard)->
  class GameScene extends Scene
    constructor: (@game)->
      super @game, "gameScene"
      @width = @game.width
      @height = @game.height
      @player = new Player(this)
      @addChildElement(@player.el)
      @camera = new Camera(@game.height/2, @game.height)
      @entityManager = new EntityManager(this)
      @addChildElement(@entityManager.el)
      @scoreBoard = new ScoreBoard(@)
      @addChildElement(@scoreBoard.el)
      @reset()

    reset: ->
      @player.pos =
        x: @width/2
        y: (5.5 * @height) / 6
      @entityManager.createPlatform(@width/2, @height - 30)
      @entityManager.reset()

    click: (event) ->
      console.log "hi from gamescene"

    update: (dt) ->
      super dt
      @player.update dt
      @camera.update dt, @player
      @entityManager.update dt, @camera
      @scoreBoard.update @camera
      if @player.pos.y > @camera.position + @game.height
        @game.gameOver(@scoreBoard.score)

      # TODO: Remove the whole render stuff
      @render()

    render: ->
      @player.render @camera
      @entityManager.render @camera
      # Move background
      @game.el.css "background-position", "0px #{-@camera.position*0.4}px"

    cleanup: ->
      super()
      console.log "GameScene.cleanup()"

  return GameScene
