require.config({
  shim: {
    zepto: {
      exports: '$'
    }
  }
});
 
require(['game'], function(Game) {
  var game = new Game($('.game'));
  game.start();
});
