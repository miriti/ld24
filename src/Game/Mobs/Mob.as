package Game.Mobs
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameMain;
	import Game.GameMap;
	import Game.Input;
	import Game.IRenderableObject;
	import Game.MapCollisionObject;
	import Game.Tiles.Tile;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Mob extends MapCollisionObject implements IRenderableObject
	{
		protected var _animations:Vector.<GameAnimSprite> = new Vector.<GameAnimSprite>();
		protected var _currentAnimation:int = -1;
		private var _matrix:Matrix = new Matrix();
		private var _ySpeed:Number = 0;
		static private const MAX_FALL_SPEED:Number = 10;
		private var _inJump:Boolean = false;
		static public const X_SPEED:Number = 7;
		static public const JUMP_POWER:Number = 7;
		
		public function Mob()
		{
			super(32, 32);
			onCollision = function(t:Tile, side:int):void
			{
				if (side == SIDE_BOTTOM)
				{
					_ySpeed = 0;
					_inJump = false;
				}
				else if (side == SIDE_TOP)
					_ySpeed = 0;
			}
		}
		
		/* INTERFACE Game.IRenderableObject */
		
		public function render():BitmapData
		{
			if (_currentAnimation != -1)
				return _animations[_currentAnimation].render();
			else
				return null;
		}
		
		public function update(deltaTime:Number):void
		{
			if (_currentAnimation != -1)
				_animations[_currentAnimation].update(deltaTime);
			
			if (Input.isLeft())
				x -= X_SPEED;
			if (Input.isRight())
				x += X_SPEED;
			
			if ((Input.isUp()) && (!_inJump))
			{
				_ySpeed = -JUMP_POWER;
				_inJump = true;
			}
			var _oy:Number = y;
			y += _ySpeed;
			if (y - _oy == _ySpeed)
				_inJump = true;
			
			_ySpeed += (deltaTime / 100);
			if (_ySpeed > MAX_FALL_SPEED)
				_ySpeed = MAX_FALL_SPEED;
		}
		
		public function get matrix():Matrix
		{
			_matrix.identity();
			_matrix.translate(_pos.x, _pos.y);
			return _matrix;
		}
	}

}