package Game.Mobs
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Game.GameAnimSprite;
	import Game.GameMain;
	import Game.GameMap;
	import Game.Input;
	import Game.IRenderableObject;
	import Game.MapCollisionObject;
	import Game.Snd;
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
		private var _rotation:Number = 0;
		
		static private const MAX_FALL_SPEED:Number = 10;
		static public const X_SPEED:Number = 3;
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
		
		protected var _rect:Rectangle = new Rectangle();
		
		protected var _skillSwimming:Number = 10;
		protected var _skillWaterbreathing:Number = 10;
		protected var _skillAirBreathing:Number = 0;
		protected var _skillWalking:Number = 0;
		protected var _skillJumping:Number = 1;
		protected var _skillFlying:Number = 0;
		
		private var _center:Point = new Point();
		
		private var m:GameMap = GameMap.Instance;
		protected var _useWorldConsts:Boolean = false;
		
		public function Mob(mw:int, mh:int)
		{
			super(mw, mh);
			onCollision = collision;
		}
		
		protected function dnaExtracting():void
		{
		
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
			{
				_ySpeed = 0;
			}
			else if ((side == SIDE_LEFT) || (side == SIDE_RIGHT))
			{
				_xSpeed = 0;
			}
		}
		
		protected function jump():void
		{
			if (!_inJump)
			{
				_ySpeed = -(JUMP_POWER + (_skillJumping / 2));
				_inJump = true;
			}
		}
		
		public function ground(dt:Number):void
		{
			if (_skillWalking >= 5)
			{
				if (Input.isLeft())
					_xSpeed -= (dt / 1000) * _skillWalking * 1.5;
				if (Input.isRight())
					_xSpeed += (dt / 1000) * _skillWalking * 1.5;
				
				if (Input.isUp())
				{
					jump();
				}
			}
			else
			{
				health -= 0.5;
			}
			
			var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
			if (t != null)
			{
				if (t is TileWater)
				{
					_mode = MODE_SWIMMING;
					Snd.I.play("splash");
				}
			}
		}
		
		public function flying(dt:Number):void
		{
			if (_skillFlying > 0)
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
				if (_skillAirBreathing < 5)
					health -= 1 * ((5 - _skillAirBreathing) / 5);
				if (_skillAirBreathing > 10)
					health += 0.01 * (dt / 33);
			}
			
			var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
			if (t != null)
			{
				if (t is TileWater)
				{
					_mode = MODE_SWIMMING;
					Snd.I.play("splash");
				}
			}
		}
		
		public function swimming(dt:Number):void
		{
			if (_skillSwimming > 0)
			{
				if (Input.isLeft())
					_xSpeed -= (dt / 1000) * _skillSwimming * 1.5;
				if (Input.isRight())
					_xSpeed += (dt / 1000) * _skillSwimming * 1.5;
				
				if (Input.isUp())
					_ySpeed -= (dt / 1000) * _skillSwimming;
				if (Input.isDown())
					_ySpeed += (dt / 1000) * _skillSwimming;
			}
			else
			{
				// die
			}
			
			var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
			if (!(t is TileWater))
			{
				if (t == null)
				{
					_mode = MODE_GROUND;
					_inJump = true;
					Snd.I.play("splash");
				}
				else if (t is TileGround)
					_mode = MODE_GROUND;
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
			
			if ((GameMap.Instance.player.dnaStrike.acting) && (GameMap.Instance.player.dnaStrike.rect.intersects(rect)))
			{
				dnaExtracting();
			}
			
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
			}
			if (_useWorldConsts)
			{
				var t:Tile = m.getTilePoint(m.getCell(_pos.x, _pos.y));
				var g:Number = t != null ? t.gravity : Tile.AIR_GRAVITY;
				var f:Number = t != null ? t.friction : _mode == MODE_GROUND ? TileGround.GROUND_FRICTION : Tile.AIR_FRICTION;
				
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
			
			if (value < _health)
				Snd.I.play("hurt");
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
		
		public function get rect():Rectangle
		{
			_rect.setTo(x + _center.x, y + _center.y, width, height);
			return _rect;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			_rotation = value;
		}
		
		public function set flipHorisontal(value:Boolean):void
		{
			_flipHorisontal = value;
		}
		
		public function set flipVertical(value:Boolean):void
		{
			_flipVertical = value;
		}
		
		public function get skillSwimming():Number
		{
			return _skillSwimming;
		}
		
		public function set skillSwimming(value:Number):void
		{
			_skillSwimming = value;
		}
		
		public function get skillWaterbreathing():Number
		{
			return _skillWaterbreathing;
		}
		
		public function set skillWaterbreathing(value:Number):void
		{
			_skillWaterbreathing = value;
		}
		
		public function get skillAirBreathing():Number
		{
			return _skillAirBreathing;
		}
		
		public function set skillAirBreathing(value:Number):void
		{
			_skillAirBreathing = value;
		}
		
		public function get skillWalking():Number
		{
			return _skillWalking;
		}
		
		public function set skillWalking(value:Number):void
		{
			_skillWalking = value;
		}
		
		public function get skillJumping():Number
		{
			return _skillJumping;
		}
		
		public function set skillJumping(value:Number):void
		{
			_skillJumping = value;
		}
		
		public function get skillFlying():Number
		{
			return _skillFlying;
		}
		
		public function set skillFlying(value:Number):void
		{
			_skillFlying = value;
		}
	}

}