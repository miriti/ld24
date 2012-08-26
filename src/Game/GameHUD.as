package Game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import Game.Mobs.Player;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class GameHUD extends Sprite
	{
		static private var _healthTitle:TextField = new TextField();
		static private var _yellowsTitle:TextField = new TextField();
		static private var _dnasTitle:TextField = new TextField();
		static private var _skillsDie:TextField = new TextField();
		
		static private var _format:TextFormat = new TextFormat("Tahoma", "18", 0xffaa00, true);
		static private const _HEALTH_:String = "HEALTH: ";
		static private const _YELLOWS_:String = "YELLOW THINGS: ";
		static public const _DNAEXT_:String = "DNA EXTRACTORS: ";
		static public var _dnasPicked:int = 0;
		
		static private var _yellowsTotal:int = 0;
		static private var _yellowsPicked:int = 0;
		
		static private var _messages:Vector.<TxtMessage>;
		
		static private var _i:GameHUD;
		static private var _skillFormat:TextFormat = new TextFormat("Tahoma", 16, 0xffffff, true);
		
		public function GameHUD()
		{
			_messages = new Vector.<TxtMessage>();
			_healthTitle.autoSize = TextFieldAutoSize.LEFT;
			_yellowsTitle.autoSize = TextFieldAutoSize.LEFT;
			_dnasTitle.autoSize = TextFieldAutoSize.LEFT;
			_skillsDie.autoSize = TextFieldAutoSize.LEFT;
			
			_skillsDie.border = true;
			_skillsDie.background = true;
			_skillsDie.backgroundColor = 0x000000;
			_skillsDie.visible = false;
			addChild(_skillsDie);
			
			health(1, 1);
			addChild(_healthTitle);
			_yellowsTitle.y = 25;
			addChild(_yellowsTitle);
			_dnasTitle.y = 50;
			addChild(_dnasTitle);
			
			_i = this;
			
			Input.addKeyboardHook(keyboardHook);
		}
		
		public static function showHints():void
		{
			_i.addChild(new GameHint(new Assets.hint001, new GameHint(new Assets.hint002, new GameHint(new Assets.hint003, new GameHint(new Assets.hint004, null)))));
		}
		
		private function keyboardHook(keyCode:int):void
		{
			if (keyCode == Keyboard.BACKQUOTE)
			{
				GameHUD.showSkills = !GameHUD.showSkills;
			}
		}
		
		static public function set showSkills(val:Boolean):void
		{
			if (val)
			{
				var p:Player = GameMap.Instance.player;
				
				_skillsDie.text = "SKILLS:\n\nSwimming:\t" + p.skillSwimming + "\n" + "Flying:\t" + p.skillFlying + "\n" + "Walking: " + p.skillWalking + "\n" + "Jumping: " + p.skillJumping + "\n" + "Water breathing: " + p.skillWaterbreathing + "\n" + "Air breathing: " + p.skillAirBreathing;
				_skillsDie.setTextFormat(_skillFormat);
				_skillsDie.x = (640 - _skillsDie.width) / 2;
				_skillsDie.y = (480 - _skillsDie.height) / 2;
			}
			
			_skillsDie.visible = val;
		}
		
		static public function get showSkills():Boolean
		{
			return _skillsDie.visible;
		}
		
		static public function setYellowsCount(cnt:int):void
		{
			_yellowsTotal = cnt;
			//yellowPickup();
		}
		
		public static function yellowPickup(cnt:int = 0):void
		{
			_yellowsPicked += cnt;
			if (_yellowsPicked == _yellowsTotal)
			{
				GameMain.Inst.gameWin();
			}
			else
			{
				_yellowsTitle.text = _YELLOWS_ + _yellowsPicked + ' / ' + _yellowsTotal;
				_yellowsTitle.setTextFormat(_format);
			}
		}
		
		public static function dnasPickup(cnt:int = 0):void
		{
			_dnasPicked += cnt;
			_dnasTitle.text = _DNAEXT_ + _dnasPicked;
			_dnasTitle.setTextFormat(_format);
		}
		
		public static function health(newHealth:Number, totalHealth:Number):void
		{
			_healthTitle.text = _HEALTH_ + Math.floor((newHealth / totalHealth) * 100) + '%';
			_healthTitle.setTextFormat(_format);
		}
		
		public static function message(txt:String):void
		{
			var newMsg:TxtMessage = new TxtMessage(txt);
			for (var i:int = 0; i < _messages.length; i++)
			{
				_messages[i].y -= newMsg.length;
			}
			newMsg.y = 480 - newMsg.height;
			_i.addChild(newMsg);
			_messages.push(newMsg);
			Snd.I.play("msg");
		}
		
		public static function update():void
		{
			for (var i:int = _messages.length - 1; i >= 0; i--)
			{
				if (_messages[i].alpha <= 0)
				{
					_messages.splice(i, 1);
				}
				else
					_messages[i].update();
			}
		}
	
	}

}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import Game.GameMain;

class TxtMessage extends TextField
{
	private var _format:TextFormat;
	
	function TxtMessage(initText:String, format:TextFormat = null):void
	{
		autoSize = TextFieldAutoSize.LEFT;
		if (_format == null)
		{
			_format = new TextFormat("Tahoma", 16, 0xff0000, true);
		}
		else
			_format = format;
		
		text = initText;
		setTextFormat(_format);
	}
	
	override public function get text():String
	{
		return super.text;
	}
	
	override public function set text(value:String):void
	{
		super.text = value;
		setTextFormat(_format);
	}
	
	public function update():void
	{
		alpha -= 0.003;
	}
}

class GameHint extends Sprite
{
	private var _next:GameHint;
	
	function GameHint(image:Bitmap, next:GameHint = null):void
	{
		addChild(image);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		_next = next;
	}
	
	private function onAddedToStage(e:Event):void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		x = (640 - width) / 2;
		y = (480 - height) / 2;
		GameMain.pause = true;
	}
	
	private function onMouseDown(e:MouseEvent):void
	{
		if (_next != null)
			parent.addChild(_next);
		else
		{
			GameMain.pause = false;
			stage.focus = GameMain.Inst;
		}
		parent.removeChild(this);
	}
}