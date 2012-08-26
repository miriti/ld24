package Game
{
	import flash.geom.Point;
	import Game.Tiles.Tile;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class MapCollisionObject
	{
		protected var _pos:Point = new Point();
		public var onCollision:Function = null;
		
		protected var _width:Number;
		protected var _height:Number;
		private var mp:GameMap;
		
		public static const SIDE_LEFT:int = 0;
		public static const SIDE_TOP:int = 1;
		public static const SIDE_RIGHT:int = 2;
		public static const SIDE_BOTTOM:int = 3;
		
		public function MapCollisionObject(cwidth:Number, cheight:Number)
		{
			setCollisionBounds(cwidth, cheight);
			mp = GameMap.Instance;
		}
		
		protected function setCollisionBounds(cwidth:Number, cheight:Number):void
		{
			_width = cwidth;
			_height = cheight;
		}
		
		private function _collision(t:Tile, side:int):void
		{
			if (onCollision != null)
				onCollision(t, side);
		}
		
		public function get pos():Point
		{
			return _pos;
		}
		
		public function set x(val:Number):void
		{
			var k:Number = val > _pos.x ? _width : 0;
			var c1:Point = mp.getCell(val + k, _pos.y);
			var c2:Point = mp.getCell(val + k, _pos.y + _height);
			var cside:int = -1;
			
			if (!mp.canPassPoint(c1))
			{
				if (k == 0)
				{
					val = (c1.x + 1) * Tile.WIDTH + 1;
					cside = SIDE_LEFT;
				}
				else
				{
					val = c1.x * Tile.WIDTH - k - 1;
					cside = SIDE_RIGHT;
				}
				_collision(mp.getTile(c1.x, c1.y), cside);
			}
			else if (!mp.canPassPoint(c2))
			{
				if (k == 0)
				{
					val = (c2.x + 1) * Tile.WIDTH + 1;
					cside = SIDE_LEFT;
				}
				else
				{
					val = c2.x * Tile.WIDTH - k - 1;
					cside = SIDE_RIGHT;
				}
				
				_collision(mp.getTile(c2.x, c2.y), cside);
			}
			
			_pos.x = val;
		}
		
		public function get x():Number
		{
			return _pos.x;
		}
		
		public function set y(val:Number):void
		{
			var k:Number = val > _pos.y ? _height : 0;
			var c1:Point = mp.getCell(_pos.x, val + k);
			var c2:Point = mp.getCell(_pos.x + _width, val + k);
			var cside:int = -1;
			
			if (!mp.canPassPoint(c1))
			{
				if (k == 0)
				{
					val = (c1.y + 1) * Tile.HEIGHT + 1;
					cside = SIDE_TOP;
				}
				else
				{
					val = c1.y * Tile.HEIGHT - k - 1;
					cside = SIDE_BOTTOM;
				}
				
				_collision(mp.getTile(c1.x, c1.y), cside);
			}
			else if (!mp.canPassPoint(c2))
			{
				if (k == 0)
				{
					val = (c2.y + 1) * Tile.HEIGHT + 1;
					cside = SIDE_TOP;
				}
				else
				{
					val = c2.y * Tile.HEIGHT - k - 1;
					cside = SIDE_BOTTOM;
				}
				
				_collision(mp.getTile(c2.x, c2.y), cside);
			}
			_pos.y = val;
		}
		
		public function get y():Number
		{
			return _pos.y;
		}
	}

}