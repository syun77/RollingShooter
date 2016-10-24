package;

import flixel.addons.effects.FlxTrail;
import flixel.FlxCamera;
import flixel.tile.FlxTilemap;
import flixel.math.FlxMath;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxState;

/**
 * メインゲーム画面
 **/
class PlayState extends FlxState {

  // マップ
  var _map:FlxTilemap;

  // プレイヤー
  var _player:Player;

  // ピボット
  var _pivot:FlxSprite;

  //
  var _circle:FlxShapeCircle;

  /**
   * 生成
   **/
  override public function create():Void {
    super.create();

    // マップ読み込み
    _map = LevelLoader.loadLevel(1);
    this.add(_map);

    var lineStyle:LineStyle = {
      thickness:1, color:FlxColor.WHITE, pixelHinting:false,
      scaleMode:null, capsStyle:null, jointStyle:null, miterLimit:1
    };
    _circle = new FlxShapeCircle(0, 0, 16, lineStyle, FlxColor.WHITE);
    _circle.alpha = 0.2;
    this.add(_circle);

    _player = new Player(FlxG.width/2, FlxG.height*0.7);
    var trail = new FlxTrail(_player);
    this.add(_player);
    this.add(trail);

    _pivot = new FlxSprite(_player.xcenter, _player.ycenter);
    _pivot.makeGraphic(8, 8, FlxColor.CYAN);
    this.add(_pivot);

    FlxG.camera.follow(_pivot);
    FlxG.camera.setScrollBoundsRect(0, 0, _map.width, _map.height, true);

  }

  /**
   * 更新
   **/
  override public function update(elapsed:Float):Void {
    super.update(elapsed);

    #if 0
    {
      var mdx = FlxG.mouse.screenX - FlxG.width/2;
      var mdy = FlxG.mouse.screenY - FlxG.height/2;
      var rad = Math.atan2(-mdy, mdx);
      var distance = Math.sqrt(mdx*mdx + mdy*mdy);
      /*
      var rad = FlxG.swipes[0].angle * FlxAngle.TO_RAD;
      var distance = FlxG.swipes[0].distance;
      */
      var dx = distance * Math.cos(rad);
      var dy = distance * -Math.sin(rad);
      _pivot.velocity.set(dx, dy);
      //FlxSpriteUtil.bound(_pivot, 0, 0, _map.width, _map.height);
    }
    #else
    {
      var dx:Int = 0;
      var dy:Int = 0;
      if(FlxG.keys.pressed.LEFT)  { dx = -1; }
      if(FlxG.keys.pressed.RIGHT) { dx = 1;  }
      if(FlxG.keys.pressed.UP)    { dy = -1; }
      if(FlxG.keys.pressed.DOWN)  { dy = 1;  }
      dx *= 10;
      dy *= 10;
      _pivot.velocity.scale(0.98);
      _pivot.velocity.x += dx;
      _pivot.velocity.y += dy;
      _player.setPivot(_pivot.x, _pivot.y);
    }
    #end

    var dx = _pivot.x - _player.xcenter;
    var dy = _pivot.y - _player.ycenter;
    var radius = FlxMath.vectorLength(dx, dy);
    _circle.radius = radius;
    _circle.x = _pivot.x - radius;
    _circle.y = _pivot.y - radius;

    if(radius > 256) {
      _circle.visible = false;
      _player.color = FlxColor.RED;
    }
    else {
      _circle.visible = true;
      _circle.alpha = 0.1 + 0.5 * (256 - radius) / 256;
      _player.color = FlxColor.CYAN;
    }

    FlxG.collide(_player, _map);
    FlxG.collide(_pivot, _map);

    #if debug
    _debug();
    #end
  }

  function _debug():Void {
    if(FlxG.keys.justPressed.ESCAPE) {
      // ESCAPEキーで終了
      System.exit(0);
    }
  }
}
