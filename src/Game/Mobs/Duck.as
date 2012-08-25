package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameMap;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Duck extends Mob
	{
		private var _sinPhase:Number = 0;
		private var _backX:Number;
		static private const DUCK_ACC:Number = 3;
		
		public function Duck()
		{
			super(32, 32);
			_animations.push(new GameAnimSprite((new Assets.mobDuck() as Bitmap).bitmapData, new Point(32, 32)));
			_currentAnimation = 0;
			center.y = 16;
		}
		
		override public function setPos(nx:Number, ny:Number):Point
		{
			_backX = nx;
			return super.setPos(nx, ny);
		}
		
		override public function update(deltaTime:Number):void
		{
			center.y = 16 + Math.sin(_sinPhase) * 4;
			_sinPhase += Math.PI * (deltaTime / 1000);
			super.update(deltaTime);
			
			var p:Player = GameMap.Instance.player;
			if ((Math.abs(x - p.x) < 200) && (Math.abs(y - p.y) < 200))
			{
				if (p.x < x)
				{
					if ((x - p.x <= 32) && (Math.abs(y - p.y) <= 32))
					{
						_interact();
					}
					else
					{
						_flipHorisontal = true;
						_xSpeed += DUCK_ACC * (deltaTime / 1000);
						if (_xSpeed > X_SPEED_MAX)
							_xSpeed = X_SPEED_MAX;
					}
				}
				if (p.x > x)
				{
					if ((p.x - x <= 32) && (Math.abs(y - p.y) <= 32))
					{
						_interact();
					}
					else
					{
						_flipHorisontal = false;
						_xSpeed -= DUCK_ACC * (deltaTime / 1000);
						if (_xSpeed < -X_SPEED_MAX)
							_xSpeed = -X_SPEED_MAX;
					}
				}
			}
			else
			{
				if (x != _backX)
				{
					if (x >= _backX)
					{
						_flipHorisontal = false;
						_xSpeed -= DUCK_ACC * (deltaTime / 1000);
						
						if (_xSpeed < -X_SPEED_MAX)
							_xSpeed = -X_SPEED_MAX;
						
						if (x - _xSpeed < _backX)
						{
							_xSpeed = 0;
							x = _backX;
						}
					}
					else if (x < _backX)
					{
						_flipHorisontal = true;
						_xSpeed += DUCK_ACC * (deltaTime / 1000);
						
						if (_xSpeed > X_SPEED_MAX)
							_xSpeed = X_SPEED_MAX;
						
						if (x + _xSpeed >= _backX)
						{
							_xSpeed = 0;
							x = _backX;
						}
					}
				}
				else
				{
					if (_xSpeed < 0)
					{
						_xSpeed += DUCK_ACC * (deltaTime / 1000);
						if (_xSpeed > 0)
							_xSpeed = 0;
					}
					else if (_xSpeed < 0)
					{
						_xSpeed -= DUCK_ACC * (deltaTime / 1000);
						if (_xSpeed > 0)
							_xSpeed = 0;
					}
				}
			}
			
			x += _xSpeed;
		}
		
		private function _interact():void
		{
			trace('op');
		}
	
	}

}