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
		private var _renderSurface:BitmapData = new BitmapData(640, 480, true, 0x00000000);
		private var _map:GameMap = GameMap.Instance;
		private var _lastTime:Number;
		
		public function GameMain()
		{
			super();
			addChild(new Bitmap(_renderSurface));
			
			addEventListener(Event.ENTER_FRAME, onRender);
			addEventListener(KeyboardEvent.KEY_DOWN, Input.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, Input.onKeyUp);
			
			_map.init((new Assets.mapTest() as Bitmap).bitmapData);
			_lastTime = new Date().getTime();
			
			focusRect = false;
		}
		
		private function onRender(e:Event):void
		{
			var _time:Number = new Date().getTime();
			_map.update(_time - _lastTime);
			_lastTime = _time;
			
			_renderSurface.fillRect(_renderSurface.rect, 0x000000);
			_renderSurface.draw(_map.render());
		}
	
	}

}