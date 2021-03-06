package jp_2dgames.game.state;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.util.FlxTimer;
import jp_2dgames.lib.Input;
import jp_2dgames.game.token.Player;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import jp_2dgames.game.particle.Particle;
import jp_2dgames.game.particle.ParticleStartLevel;
import jp_2dgames.game.gui.StageClearUI;
import jp_2dgames.lib.Snd;
import flixel.util.FlxColor;
import flixel.FlxG;
import jp_2dgames.lib.MyShake;
import jp_2dgames.game.gui.GameoverUI;
import jp_2dgames.game.global.Global;
import flixel.FlxState;

/**
 * 状態
 **/
private enum State {
  Init;
  Main;
  DeadWait;
  Gameover;
  Stageclear;
}

/**
 * メインゲーム画面
 **/
class PlayState extends FlxState {

  var _state:State = State.Init;

  var _walls:FlxTilemap;
  var _player:Player;
  var _seq:SeqMgr;

  /**
   * 生成
   **/
  override public function create():Void {
    super.create();

    // 初期化
    Global.initLevel();

    // マップ読み込み
//    _walls = LevelLoader.loadLevel(Global.level);
    Field.loadLevel(Global.level);
    _walls = Field.createWallTile();
    this.add(_walls);

    // プレイヤー生成
    {
      var pt = Field.getStartPosition();
      _player = new Player(pt.x, pt.y);
      pt.put();
    }

    // パーティクル生成
    Particle.createParent(this);

    // オブジェクト配置
    Field.createObjects();

    // BGM再生
    if(Global.level%2 == 1) {
      Snd.playMusic("1");
    }
    else {
      Snd.playMusic("2");
    }

    // シーケンス管理生成
    _seq = new SeqMgr(_player, _walls);

    if(Global.level == Global.MAX_LEVEL-1) {
      // スクロール設定
      FlxG.camera.follow(_player, FlxCameraFollowStyle.PLATFORMER, 0.1);
      FlxG.worldBounds.set(0, 0, Field.getWidth(), Field.getHeight());
    }
  }

  /**
   * 破棄
   **/
  override public function destroy():Void {

    Particle.destroyParent();
    super.destroy();
  }

  /**
   * 更新
   **/
  override public function update(elapsed:Float):Void {
    super.update(elapsed);

    switch(_state) {
      case State.Init:
        // ゲーム開始
        _updateInit();
        _state = State.Main;

      case State.Main:
        _updateMain();

      case State.DeadWait:
        // 死亡演出終了待ち

      case State.Gameover:
        if(Input.press.B) {
          // やり直し
          FlxG.resetState();
//          FlxG.switchState(new PlayInitState());
        }
      case State.Stageclear:
        if(Input.press.B) {
          // 次のレベルに進む
          StageClearUI.nextLevel();
        }
    }
    #if debug
    _updateDebug();
    #end
  }

  /**
   * 更新・初期化
   **/
  function _updateInit():Void {
    ParticleStartLevel.start(this);
  }

  /**
   * 更新・メイン
   **/
  function _updateMain():Void {

    switch(_seq.proc()) {
      case SeqMgr.RET_DEAD:
        // ゲームオーバー
        _startGameover();
        return;
      case SeqMgr.RET_STAGECLEAR:
        // ステージクリア
        this.add(new StageClearUI(false));
        _state = State.Stageclear;
        _player.vanish();
        Snd.stopMusic();
    }
  }


  /**
   * ゲームオーバー開始
   **/
  function _startGameover():Void {
    // 動きを止める
    _player.active = false;
    Snd.playSe("kya");
    new FlxTimer().start(0.5, function(timer:FlxTimer) {
      Snd.playSe("explosion");
      _state = State.Gameover;
      this.add(new GameoverUI(false));
      _player.vanish();
      MyShake.high();
      FlxG.camera.flash(FlxColor.WHITE, 0.5);
    });
    _state = State.DeadWait;
    Snd.stopMusic();
  }

  // -----------------------------------------------
  // ■アクセサ

  /**
   * デバッグ
   **/
  function _updateDebug():Void {

    if(FlxG.keys.justPressed.ESCAPE) {
      // 強制終了
      throw "Terminate.";
    }
    if(FlxG.keys.justPressed.L) {
      // リスタート
//      FlxG.resetState();
      FlxG.switchState(new PlayInitState());
    }
  }

}
