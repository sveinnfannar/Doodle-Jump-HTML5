define ["entity"], (Entity) ->
  class Item extends Entity
    constructor: (gameScene, rect) ->
      super(gameScene, rect)
      @collected = false

    makeElement: ->
      return $('<div class="item">')

    collision: ->
      @collected = true

    dead: ->
      return @collected

  return Item
