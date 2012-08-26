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
		private var _intro:Intro;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_intro = new Intro();
			addChild(_intro);
		}
		
		public function startGame():void
		{
			removeChild(_intro);
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
import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import Game.GameMain;

class Intro extends flash.display.Sprite
{
	private var bmp:Bitmap;
	private var _btn:Btn = new Btn();
	
	function Intro():void
	{
		super();
		bmp = new Assets.bmpIntro();
		addChild(bmp);
		_btn.x = 215;
		_btn.y = 275;
		addChild(_btn);
		_btn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		var _copyright:TextField = new TextField();
		_copyright.autoSize = TextFieldAutoSize.LEFT;
		_copyright.selectable = false;
		_copyright.htmlText = '<a href="http://blog.miriti.ru/">Michael "KEFIR" Miriti</a> special for Ludum Dare #24 (08/27/2012).';
		_copyright.setTextFormat(new TextFormat("Tahoma", 12, 0x808080, true));
		_copyright.x = 0;
		_copyright.y = 480 - _copyright.height;
		addChild(_copyright);
	}
	
	private function onMouseDown(e:MouseEvent):void
	{
		(parent as Main).startGame();
	}
}

class Btn extends flash.display.Sprite
{
	public function Btn():void
	{
		super();
		graphics.beginFill(0xffffff);
		graphics.drawRect(0, 0, 220, 45);
		graphics.endFill();
		buttonMode = true;
		alpha = 0;
	}
}