package;

import flixel.FlxGame;
import openfl.display.Sprite;
import jp_2dgames.game.state.BootState;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(0, 0, BootState, 1, 60, 60, true));
  }
}
