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
	import Game.Tiles.TileGround;
	import Game.Tiles.TileWater;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Mob extends MapCollisionObject implements IRenderableObject
	{
		protected var _animations:Vector.<GameAnimSprite> = new Vector.<GameAnimSprite>();
		protected var _currentAnimation:int = -1;
		
		protected var _health:Number;
		protected var _healthMax:Number;
		
		protected var _controlled:Boolean = false;
		
		private var _matrix:Matrix = new Matrix();
		static private const MAX_FALL_SPEED:Number = 10;
		static public const X_SPEED:Number = 7;
		static public const X_SPEED_MAX:Number = 5;
		static public const JUMP_POWER:Number = 7;
		
		static public const MODE_SWIMMING:int = 0
		static public const MODE_FLYING:int = 1;
		static public const MODE_GROUND:int = 2;
		
		protected var _mode:int = MODE_SWIMMING;
		protected var _xSpeed:Number = 0;
		protected var _ySpeed:Number = 0;
		protected var _inJump:Boolean = false;
		
		protected var _flipHorisontal:Boolean = false;
		protected var _flipVertical:Boolean = false;
		
		public var skillSwimming:Number = 10;
		public var skillWaterbreathing:Number = 10;
		public var skillAirBreathing:Number = 0;
		public var skillWalking:Number = 0;
		public var skillJumping:Number = 0;
		public var skillFlying:Number = 0;
		
		private var _center:Point = new Point();
		
		private var m:GameMap = GameMap.Instance;
		
		public function Mob(mw:int, mh:int)
		{
			super(mw, mh);
			onCollision = collision;
		}
		
		public function setPos(nx:Number, ny:Number):Point
		{
			_pos.setTo(nx, ny);
			return _pos;
		}
		
		private function collision(t:Tile, side:int):void
		{
			if (side == SIDE_BOTTOM)
			{
				if (t is TileGround)
				{
					if (_mode == MODE_FLYING)
					{
						_mode = MODE_GROUND;
					}
				}
				
				_ySpeed = 0;
				_inJump = false;
			}
			else if (side == SIDE_TOP)
				_ySpeed = 0;
		}
		
		public function ground(dt:Number):void
		{
			if (skillWalking > 0)
			{
				if (Input.isLeft())
					x -= X_SPEED;
				if (Input.isRight())
					x += X_SPEED;
				
				if ((Input.isUp()) && (!_inJump))
				{
					_ySpeed = -JUMP_POWER;
					_inJump = true;
				}
			}
			else
			{
				health -= 0.5;
			}
		}
		
		public function flying(dt:Number):void
		{
			if (skillFlying > 0)
			{
				if (Input.isLeft())
					_xSpeed -= (dt / 1000) * 25;
				if (Input.isRight())
					_xSpeed += (dt / 1000) * 25;
				if (Input.isUp())
					_ySpeed -= (dt / 1000) * 25;
				if (Input.isDown())
					_ySpeed += (dt / 1000) * 25;
			}
			else
			{
				health -= 0.2;
			}
			
			var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
			if (t != null)
			{
				if (t is TileWater)
					_mode = MODE_SWIMMING;
			}
		}
		
		public function swimming(dt:Number):void
		{
			if (skillSwimming > 0)
			{
				if (Input.isLeft())
					_xSpeed -= (dt / 1000) * 15;
				if (Input.isRight())
					_xSpeed += (dt / 1000) * 15;
				
				if (Input.isUp())
					_ySpeed -= (dt / 1000) * 15;
				if (Input.isDown())
					_ySpeed += (dt / 1000) * 15;
			}
			else
			{
				// die
			}
			
			var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
			if (!(t is TileWater))
			{
				if (t == null)
					_mode = MODE_FLYING;
			}
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
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
			
			if (_controlled)
			{
				switch (_mode)
				{
					case(MODE_GROUND):
						ground(deltaTime);
						break;
					case(MODE_FLYING):
						flying(deltaTime);
						break;
					case(MODE_SWIMMING):
						swimming(deltaTime);
						break;
				}
				
				var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
				var g:Number = t != null ? t.gravity : Tile.AIR_GRAVITY;
				var f:Number = t != null ? t.friction : Tile.AIR_FRICTION;
				
				if (Math.abs(_xSpeed) > X_SPEED_MAX)
				{
					_xSpeed = X_SPEED_MAX * ((_xSpeed < 0) ? -1 : 1);
				}
				x += _xSpeed;
				
				if (_xSpeed < 0)
				{
					_flipHorisontal = true;
					_xSpeed += f * (deltaTime / 1000);
					if (_xSpeed > 0)
						_xSpeed = 0;
				}
				else if (_xSpeed > 0)
				{
					_flipHorisontal = false;
					_xSpeed -= f * (deltaTime / 1000);
					if (_xSpeed < 0)
						_xSpeed = 0;
				}
				_ySpeed += g * (deltaTime / 1000);
				
				if (_ySpeed < 0)
				{
					_ySpeed += f * (deltaTime / 1000);
					if (_ySpeed > 0)
						_ySpeed = 0;
				}
				else if (_ySpeed > 0)
				{
					_ySpeed -= f * (deltaTime / 1000);
					if (_ySpeed < 0)
						_ySpeed = 0;
				}
				
				if (_ySpeed > MAX_FALL_SPEED)
					_ySpeed = MAX_FALL_SPEED;
				var _oy:Number = y;
				y += _ySpeed;
				if (y - _oy == _ySpeed)
					_inJump = true;
			}
		}
		
		public function get matrix():Matrix
		{
			_matrix.identity();
			_matrix.translate(_pos.x, _pos.y);
			return _matrix;
		}
		
		public function get flipHorisontal():Boolean
		{
			return _flipHorisontal;
		}
		
		public function get flipVertical():Boolean
		{
			return _flipVertical;
		}
		
		public function get health():Number
		{
			return _health;
		}
		
		public function set health(value:Number):void
		{
			if (value < 0)
				value = 0;
			if (value > _healthMax)
				value = _healthMax;
			_health = value;
		}
		
		public function get center():Point
		{
			return _center;
		}
		
		public function set center(value:Point):void
		{
			_center = value;
		}
	}

}