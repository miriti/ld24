package Game.Mobs
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameMap;
	import Game.IRenderableObject;
	import Game.Tiles.Tile;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Mob implements IRenderableObject
	{
		protected var _animations:Vector.<GameAnimSprite> = new Vector.<GameAnimSprite>();
		protected var _currentAnimation:int = -1;
		
		protected var _pos:Point = new Point();
		
		private var _matrix:Matrix = new Matrix();
		
		public function Mob()
		{
		
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
		}
		
		public function get matrix():Matrix
		{
			_matrix.identity();
			_matrix.translate(_pos.x, _pos.y);
			return _matrix;
		}
		
		public function get pos():Point
		{
			return _pos;
		}
		
		public function set x(val:Number):void
		{
			setPosition(val, _pos.y);
		}
		
		public function get x():Number
		{
			return _pos.x;
		}
		
		public function set y(val:Number):void
		{
			setPosition(_pos.x, val);
		}
		
		public function get y():Number
		{
			return _pos.y;
		}
		
		public function setPosition(newX:int, newY:int):void
		{
			var cc:Point = new Point(Math.floor(x / Tile.WIDTH), Math.floor(y / Tile.HEIGHT));
			var tc:Vector.<Point> = new Vector.<Point>();
			
			if (newX != _pos.x)
			{
				var a:Number = newX > _pos.x ? 1 : -1;
				
				tc.push(new Point(cc.x + a, cc.y));
				if (_pos.y % Tile.HEIGHT != 0)
					tc.push(new Point(cc.x + a, cc.y + 1));
			}
			
			if (newY != _pos.y)
			{
				var a:Number = newY > _pos.y ? 1 : -1;
				
				tc.push(new Point(cc.x, cc.y + a));
				if (_pos.x % Tile.WIDTH != 0)
					tc.push(new Point(cc.x + 1, cc.y + a));
			}
			for (var i:int = 0; i < tc.length; i++)
			{
				if (!GameMap.Instance.canPass(tc[i].x, tc[i].y))
					return;
			}
			
			// WHAT THE FUC* WAS THAT?? need a little rest...
			
			_pos.setTo(newX, newY);
		}
	}

}