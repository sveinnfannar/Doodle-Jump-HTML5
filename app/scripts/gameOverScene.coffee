define [], ->
  class GameOverScene
    END_TIME = 250
    SCROLL_SPEED = 400

    constructor: (@game, @gameScene) ->
      @time = 0
      @gameover = $('<div class="gameover">GAME<br />OVER</div>')
      END_TIME *= @game.ratio.y
      SCROLL_SPEED *= @game.ratio.y
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
