define ["platform"], (Platform) ->
  Function::property = (prop, desc) ->
    Object.defineProperty @prototype, prop, desc

  class FragilePlatform extends Platform
    FRACTURE_TIME = 1
    DIE_TIME = 1
    DIE_SPEED = 50
    NORMAL = 0
    FRACTURING = 1
    DYING = 2
    DEAD = 3

    constructor: (rect) ->
      super rect
      @state = NORMAL
      @el.addClass "fragile"
      @fracture_time = -1
      @die_time = -1

    update: (dt) ->
      super dt
      if @state == FRACTURING
        @fracture_time += dt
        if @fracture_time > FRACTURE_TIME
          @el.removeClass "fracturing"
          @el.addClass "dying"
          @state = DYING
          @die_time = 0
      else if @state == DYING
        @die_time += dt
        @el.removeClass "dying"
        if @die_time > DIE_TIME
          @state = DEAD
        else
          @y += DIE_SPEED * dt

    dead: ->
      console.log(@)
      if @state == DEAD
        console.log "returning", @state == DEAD, @state
      return @state == DEAD

    solid: ->
      return @state != DEAD and @state != DYING

    collision: ->
      super()
      if @state == NORMAL
        @el.removeClass "fragile"
        @el.addClass "fracturing"
        @state = FRACTURING
        @fracture_time = 0

  return FragilePlatform
