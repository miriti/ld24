package Game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class GameMain extends Sprite
	{
		public static var Inst:GameMain;
		
		private var _renderSurface:BitmapData = new BitmapData(640, 480, true, 0x00000000);
		private var _map:GameMap = GameMap.Instance;
		private var _lastTime:Number;
		
		public static var pause:Boolean = false;
		
		private var _surfaceBmp:Bitmap;
		private var _gameHUD:GameHUD;
		
		public function GameMain()
		{
			super();
			Inst = this;
			
			new Snd();
			
			gameStart();
		
		}
		
		public function gameOver():void
		{
			removeChild(_surfaceBmp);
			removeChild(_gameHUD);
			removeEventListener(Event.ENTER_FRAME, onRender);
			
			addChild(new Assets.bmpGameOver());
		}
		
		public function gameWin():void
		{
			removeChild(_surfaceBmp);
			removeChild(_gameHUD);
			removeEventListener(Event.ENTER_FRAME, onRender);
			
			addChild(new Assets.bmpWin());
		}
		
		public function gameStart():void
		{
			_surfaceBmp = new Bitmap(_renderSurface);
			_gameHUD = new GameHUD();
			
			addChild(_surfaceBmp);
			addChild(_gameHUD);
			
			addEventListener(Event.ENTER_FRAME, onRender);
			addEventListener(KeyboardEvent.KEY_DOWN, Input.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, Input.onKeyUp);
			
			_map.init((new Assets.mapLayer1() as Bitmap).bitmapData);
			_map.init2((new Assets.mapLayer2() as Bitmap).bitmapData);
			_lastTime = new Date().getTime();
			
			focusRect = false;
		}
		
		private function onRender(e:Event):void
		{
			var _time:Number = new Date().getTime();
			if (!pause)
			{
				_map.update(_time - _lastTime);
				GameHUD.update();
			}
			_lastTime = _time;
			
			_renderSurface.fillRect(_renderSurface.rect, 0x000000);
			_renderSurface.draw(_map.render());
		}
	
	}

}