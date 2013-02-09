define [], ->
  class Scene
    constructor: (@game, @name) ->
      @el = $('<div class="' + @name + '"></div>')

    update: (dt) ->
      # Called every frame
    
    cleanup: ->
      # Remove the element, clean up event bindings, etc.
      @el.remove()

    addChildElement: (element) ->
      @el.append(element)

  return Scene
