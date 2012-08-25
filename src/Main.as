package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Game.GameMain;

	/**
	 * ...
	 * @author Michael Miriti
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		private var _gameMain:GameMain = new GameMain();

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.DEACTIVATE, onDeactivate);
			addEventListener(Event.ACTIVATE, onActivate);
			addEventListener(MouseEvent.CLICK, onClick);
			
			addChild(_gameMain);
			stage.focus = _gameMain;
		}
		
		private function onDeactivate(e:Event):void 
		{
			GameMain.pause = false;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			onActivate(null);
		}
		
		private function onActivate(e:Event):void 
		{
			stage.focus = _gameMain;
		}

	}

}