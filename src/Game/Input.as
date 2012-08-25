package Game
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Input
	{
		private static var _keysPressed:Array = new Array(256);
		private static var _mouseDown:Boolean = false;
		
		private static var hooks:Vector.<Function> = new Vector.<Function>();
		
		public static function addKeyboardHook(hook:Function):void
		{
			hooks.push(hook);
		}
		
		public static function onMouseDown(e:MouseEvent):void
		{
			_mouseDown = true;
		}
		
		public static function onMouseUp(e:MouseEvent):void
		{
			_mouseDown = false;
		}
		
		public static function onKeyDown(e:KeyboardEvent):void
		{
			_keysPressed[e.keyCode] = true;
			for (var i:int = 0; i < hooks.length; i++)
			{
				hooks[i](e.keyCode);
			}
		}
		
		public static function onKeyUp(e:KeyboardEvent):void
		{
			_keysPressed[e.keyCode] = false;
		}
		
		public static function isLeft():Boolean
		{
			return _keysPressed[Keyboard.LEFT] || _keysPressed[Keyboard.A];
		}
		
		public static function isRight():Boolean
		{
			return _keysPressed[Keyboard.RIGHT] || _keysPressed[Keyboard.D];
		}
		
		public static function isUp():Boolean
		{
			return _keysPressed[Keyboard.UP] || _keysPressed[Keyboard.W];
		}
		
		public static function isDown():Boolean
		{
			return _keysPressed[Keyboard.DOWN] || _keysPressed[Keyboard.S];
		}
	}

}