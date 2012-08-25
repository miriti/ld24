package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Dolphin extends Mob
	{
		static public const DOLPHIN_SPEED:Number = 3;
		
		private var _bmp:Bitmap = new Assets.mobDolphin;
		
		private var _direction:int = 1;
		private var _totalTime:Number = 0;
		private var _sinPhase:Number = 0;
		
		public function Dolphin()
		{
			super(64, 32);
			_animations.push(new GameAnimSprite(_bmp.bitmapData, new Point(64, 32)));
			_currentAnimation = 0;
		}
		
		override public function update(deltaTime:Number):void
		{
			if (_totalTime >= 4000)
			{
				_totalTime = 0;
				_direction *= -1;
				if (_direction == -1)
					_flipHorisontal = true;
				else
					_flipHorisontal = false;
			}
			else
			{
				_totalTime += deltaTime;
			}
			
			x += _xSpeed = DOLPHIN_SPEED * _direction;
			_sinPhase += Math.PI * (deltaTime / 1000)
			super.update(deltaTime);
		}
		
		override public function get y():Number 
		{
			return super.y + Math.sin(_sinPhase) * 15;
		}
		
		override public function set y(value:Number):void 
		{
			super.y = value;
		}
	
	}

}