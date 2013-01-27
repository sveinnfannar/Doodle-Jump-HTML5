define [], ->
  class Platform
    constructor: (rect) ->
      @el = $('<div class="platform">')
      @rect = rect
      @rect.right = @rect.x + 90 # A small quick-fix because @el.width() returns 0 at this point
      @el.css {
        left: rect.x
        top: rect.y
      }


  return Platform
