define [], ->
  class GameOverScene
    END_TIME = 200
    SCROLL_SPEED = 400

    constructor: (@game, @gameScene) ->
      @time = 0
      @gameover = $('<div class="gameover">GAME<br />OVER</div>')
      width = @game.width / 6
      @gameover.css {
        'left': "#{@game.width / 2 - width*3/2}px",
        'font-size': "#{width}px"
      }
      END_TIME *= @game.ratio
      SCROLL_SPEED *= @game.ratio
      console.log "game over"
    
    buildScene: ->
      return [@gameover, @gameScene.player.el].concat (platform.el for platform in @gameScene.platformManager.platforms)

    onFrame: (dt) ->
      if @time < END_TIME
        @time += dt * SCROLL_SPEED
      if @gameScene.player.pos.y - @gameScene.camera.position - @gameScene.player.el.height() <  @game.height
        @gameScene.player.update dt
      @gameScene.player.render @gameScene.camera
      @gameover.css $.fx.cssPrefix + 'transform', "translate(0px,#{@time}px)"


  return GameOverScene
