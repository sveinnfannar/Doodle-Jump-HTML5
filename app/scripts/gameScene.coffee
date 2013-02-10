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
      @music = new Howl({
        urls: ['/sound/popcorn.ogg'],
        buffer: true,
        loop: true
      }).play()
      @sounds = new Howl({
        urls: ['/sound/sprite_sound.wav'],
        sprite: {
          'buzzer': [0, 278],
          'jump': [350, 1051],
          'spring': [1100, 1000],
          'coin': [2100, 500]
        }
      })

    reset: ->
      @player.pos =
        x: @width/2 + 20
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
        @music.pause()
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
