define ["entity"], (Entity) ->
  class Item extends Entity
    constructor: (gameScene, x, y) ->
      super gameScene, x, y
      @collected = false

    makeElement: ->
      return $('<div class="item">')

    collision: ->
      @collected = true

    dead: ->
      return @collected

  return Item
