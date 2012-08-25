package Game
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class GameHUD extends Sprite
	{
		static private var _healthTitle:TextField = new TextField();
		static private var _yellowsTitle:TextField = new TextField();
		static private var _format:TextFormat = new TextFormat("Tahoma", "20", 0x00ff00, true);
		static private const _HEALTH_:String = "HEALTH: ";
		static private const _YELLOWS_:String = "YELLOW THINGS: ";
		
		static private var _yellowsTotal:int = 0;
		static private var _yellowsPicked:int = 0;
		
		private var _menuShown:Boolean = false;
		private var _interactMenu:InteractMenu;
		
		public function GameHUD()
		{
			_healthTitle.autoSize = TextFieldAutoSize.LEFT;
			_yellowsTitle.autoSize = TextFieldAutoSize.LEFT;
			
			health(1, 1);
			addChild(_healthTitle);
			_yellowsTitle.y = _healthTitle.height;
			addChild(_yellowsTitle);
		
		/*_interactMenu = new InteractMenu();
		   _interactMenu.x = (640 - _interactMenu.width) / 2;
		   _interactMenu.y = (480 - _interactMenu.height) / 2;
		   _interactMenu.visible = false;
		   addChild(_interactMenu);
		
		 Input.addKeyboardHook(onKeyDown);*/
		}
		
		static public function setYellowsCount(cnt:int):void
		{
			_yellowsTotal = cnt;		
			yellowPickup();
		}
		
		private function onKeyDown(key:int):void
		{
			if (key == Keyboard.SPACE)
			{
				if (!_menuShown)
				{
					_interactMenu.visible = true;
					_menuShown = true;
					GameMain.pause = true;
					stage.focus = _interactMenu;
				}
				else
				{
					_interactMenu.visible = false;
					_menuShown = false;
					GameMain.pause = false;
					stage.focus = GameMain.Inst;
				}
			}
		}
		
		public static function yellowPickup(cnt:int = 0):void
		{
			_yellowsPicked += cnt;
			_yellowsTitle.text = _YELLOWS_ + _yellowsPicked + ' / ' + _yellowsTotal;
			_yellowsTitle.setTextFormat(_format);
		}
		
		public static function health(newHealth:Number, totalHealth:Number):void
		{
			_healthTitle.text = _HEALTH_ + Math.floor((newHealth / totalHealth) * 100) + '%';
			_healthTitle.setTextFormat(_format);
		}
	
	}

}
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class InteractMenu extends Sprite
{
	private var _btnMate:InteractMenuItem = new InteractMenuItem("MATE");
	private var _btnFight:InteractMenuItem = new InteractMenuItem("FIGHT");
	
	public function InteractMenu():void
	{
		super();
		graphics.beginFill(0xaaaaaa);
		graphics.drawRect(0, 0, 250, 150);
		graphics.endFill();
		
		_btnMate.x = 20;
		_btnMate.y = 20;
		
		_btnFight.x = 20;
		_btnFight.y = _btnMate.y + _btnMate.height + 20;
		
		addChild(_btnMate);
		addChild(_btnFight);
		
		_btnMate.addEventListener(MouseEvent.MOUSE_DOWN, onMate);
		_btnFight.addEventListener(MouseEvent.MOUSE_DOWN, onFight);
	}
	
	private function onMate(e:MouseEvent):void
	{
		trace('mate');
	}
	
	private function onFight(e:MouseEvent):void
	{
		trace('fight');
	}
}

class InteractMenuItem extends SimpleButton
{
	private var _txtUp:TextField = new TextField();
	private var _txtOv:TextField = new TextField();
	
	private var _tfUp:TextFormat = new TextFormat("Tahoma", 25, 0x0, true);
	private var _tfOv:TextFormat = new TextFormat("Tahoma", 25, 0xff0000, true);
	
	public function InteractMenuItem(text:String):void
	{
		_txtOv.autoSize = TextFieldAutoSize.LEFT;
		_txtOv.text = text;
		_txtOv.setTextFormat(_tfOv);
		
		_txtUp.autoSize = TextFieldAutoSize.LEFT;
		_txtUp.text = text;
		_txtUp.setTextFormat(_tfUp);
		
		super(_txtUp, _txtOv);
	}
}