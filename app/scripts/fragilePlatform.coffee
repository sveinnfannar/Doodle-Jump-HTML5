define ["platform"], (Platform) ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class FragilePlatform extends Platform
    DIE_TIME = 1
    DIE_SPEED = 50
    NORMAL = 0
    DYING = 1
    DEAD = 2
    FRAME_SIZE = {width: 4.5, height: 1.2}
    ANIMATION_FRAMES = 4

    constructor: (gameScene, x, y) ->
      super gameScene, x, y
      @state = NORMAL
      @el.addClass "fragile"
      @die_time = 0
      @animation_index = 0

    update: (dt) ->
      super dt
      if @state == DYING
        @die_time += dt
        if @die_time > 0.3
          @animation_index = 3
        else if @die_time > 0.15
          @animation_index = 2
        else if @die_time > 0
          @animation_index = 1

        @el.css "background-position", "#{-FRAME_SIZE.width*@animation_index}em 0"
        
        if @die_time > DIE_TIME
          @state = DEAD
        else
          @y += DIE_SPEED * dt

    dead: ->
      return @state == DEAD

    checkPlayerCollision: (player, oldPosition) ->
      if @state != DEAD and @state != DYING
        super player, oldPosition

    collision: ->
      super()
      if @state == NORMAL
        @state = DYING

  return FragilePlatform
