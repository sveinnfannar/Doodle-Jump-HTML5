define [], ->
  class Platform
    constructor: (rect) ->
      @rect = rect
      @el = $('<div class="platform">')
      @el.css {
        left: rect.x
        top: rect.y
        width: rect.width
        height: rect.height
      }
        

  return Platform
