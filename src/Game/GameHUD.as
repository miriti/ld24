package Game
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class GameHUD extends Sprite
	{
		static private var _healthTitle:TextField = new TextField();
		static private var _format:TextFormat = new TextFormat("Tahoma", "20", 0x00ff00, true);
		static private const _HEALTH_:String = "HEALTH: ";
		
		public function GameHUD()
		{
			_healthTitle.autoSize = TextFieldAutoSize.LEFT;
			
			health(1, 1);
			addChild(_healthTitle);
		}
		
		public static function health(newHealth:Number, totalHealth:Number):void
		{
			_healthTitle.text = _HEALTH_ + Math.floor((newHealth / totalHealth) * 100) + '%';
			_healthTitle.setTextFormat(_format);
		}
	
	}

}