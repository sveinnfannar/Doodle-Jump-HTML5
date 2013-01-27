define [], ->
  class Platform
    constructor: (rect) ->
      @el = $('<div class="platform">')
      @rect = rect
      @rect.right = @rect.x + @el.width()
      @el.css {
        left: rect.x
        top: rect.y
      }


  return Platform
