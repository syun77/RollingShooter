package ;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

/**
 * プレイヤー
 **/
class Player extends FlxSprite {

  var _position:FlxPoint = new FlxPoint();
  var _pivot:FlxPoint = new FlxPoint();

  public var xcenter(get, never):Float;
  public var ycenter(get, never):Float;

  /**
   * コンストラクタ
   **/
  public function new(X:Float, Y:Float) {
    super(X, Y);
    makeGraphic(16, 16, FlxColor.WHITE);
  }

  /**
   * 更新
   **/
  override public function update(elapsed:Float):Void {
    super.update(elapsed);

    _move();
  }

  /**
   * ピボットを設定する
   **/
  public function setPivot(X:Float, Y:Float):Void {
    _pivot.set(X, Y);
  }

  /**
   * 移動する
   **/
  function _move():Void {
    _position.x = x + origin.x;
    _position.y = y + origin.y;

    // 回転する
    _position.rotate(_pivot, 2);
    var dx = _position.x - origin.x - x;
    var dy = _position.y - origin.y - y;
    velocity.set(dx, dy);
    velocity.scale(FlxG.updateFramerate);
  }

  function get_xcenter():Float {
    return x + origin.x;
  }
  function get_ycenter():Float {
    return y + origin.y;
  }
}
