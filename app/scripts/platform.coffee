define ["entity"], (Entity) ->
  class Platform extends Entity

    makeElement: ->
      return $('<div class="platform">')

  return Platform
