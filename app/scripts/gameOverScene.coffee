define [], ->
  class GameOverScene
    constructor: (@game, @gameScene) ->
      @time = 0
      @gameover = $('<div class="gameover">GAME<br />OVER</div>')
      console.log "game over"
    
    buildScene: ->
      return [@gameover, @gameScene.player.el].concat (platform.el for platform in @gameScene.platformManager.platforms)

    onFrame: (dt) ->
      if @time < 250
        @time += dt * 400
      if @gameScene.player.pos.y - @gameScene.camera.position - @gameScene.player.el.height() <  @game.height
        @gameScene.player.update dt
      @gameScene.player.render @gameScene.camera
      @gameover.css $.fx.cssPrefix + 'transform', "translate(0px,#{@time}px)"


  return GameOverScene
