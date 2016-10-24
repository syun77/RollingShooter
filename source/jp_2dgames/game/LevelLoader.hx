package jp_2dgames.game;

import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;

/**
 * レベルの読み込み
 **/
class LevelLoader {
  public static function loadLevel(level:Int):FlxTilemap {

    var name = StringTools.lpad(Std.string(level), "0", 3);
    var tileMap = new TiledMap('assets/data/levels/${name}.tmx');
    var mainLayer:TiledTileLayer = cast tileMap.getLayer("main");

    var map = new FlxTilemap();
    map.loadMapFromArray(mainLayer.tileArray, tileMap.width, tileMap.height, "assets/data/level/tileset.png", 32, 32, 1);

    return map;
  }
}
