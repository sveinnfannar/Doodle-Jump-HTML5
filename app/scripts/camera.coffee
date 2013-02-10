define [], ->
  class Camera
    MIN_CAMERA_MOVEMENT = 2

    constructor: (y, screen_size) ->
      @center = screen_size / 2
      @position = y - @center
      @target = y - @center

    update: (dt, player) ->
      #Update target based on current player position
      if player.pos.y < @position + @center
        @target = player.pos.y - @center
      else
        @target = @position

      #target is always lower than position
      diff = @position - @target
      
      #Move camera further the further from our target we are
      dist = diff * 0.15

      #Make sure we always travel a reasonable amount
      if dist < MIN_CAMERA_MOVEMENT
        dist = MIN_CAMERA_MOVEMENT

      #Make sure we don't move past our target
      if dist > diff
        dist = diff

      @position -= dist

  return Camera
