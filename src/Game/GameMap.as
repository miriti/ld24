package Game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Game.Mobs.Mob;
	import Game.Mobs.Player;
	import Game.Objects.YellowThing;
	import Game.Tiles.Tile;
	import Game.Tiles.TileFactory;
	import Game.Tiles.TileSolid;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class GameMap implements IRenderableObject
	{
		private static var _Instance:GameMap;
		
		private var _bmpBack:BitmapData = (new Assets.bmpBack() as Bitmap).bitmapData;
		
		private var _bitmapResult:BitmapData = new BitmapData(640, 480, true, 0x00000000);
		private var _tileData:Array;
		
		private var _tilesX:int = 0;
		private var _tilesY:int = 0;
		
		private var _shiftX:int = 0;
		private var _shiftY:int = 0;
		
		private var _topLeftTile:Point = new Point(0, 0);
		private var _countTileWidth:int = 21;
		private var _countTileHeigh:int = 16;
		
		private var _mobs:Vector.<Mob>;
		private var _player:Player;
		private var _objectsData:Array;
		private var _backMatrix:Matrix = new Matrix();
		
		public function GameMap()
		{
			if (_Instance != null)
				throw new Error("Do not use constructor! Use GameMap.Instance to get an instance");
			else
			{
				_Instance = this;
				_mobs = new Vector.<Mob>();
			}
		}
		
		public function addMob(m:Mob):void
		{
			_mobs.push(m);
		}
		
		public function delMob(m:Mob):void
		{
			var ind:int;
			if ((ind = _mobs.indexOf(m)) != -1)
			{
				_mobs.splice(ind, 1);
			}
		}
		
		public function getCell(x:Number, y:Number):Point
		{
			return new Point(Math.floor(x / Tile.WIDTH), Math.floor(y / Tile.HEIGHT));
		}
		
		public function canPass(x:int, y:int):Boolean
		{
			if ((x >= 0) && (x < _tilesX) && (y >= 0) && (y < _tilesY))
			{
				return ((_tileData[x][y] == null) || ((_tileData[x][y] != null) && (!(_tileData[x][y] is TileSolid))));
			}
			else
			{
				return false;
			}
		}
		
		public function canPassPoint(p:Point):Boolean
		{
			return canPass(p.x, p.y);
		}
		
		public function getTile(x:int, y:int):Tile
		{
			if ((x >= 0) && (x < _tileData.length) && (y >= 0) && (y < _tileData[x].length))
			{
				return _tileData[x][y];
			}
			else
				return null;
		}
		
		public function getTilePoint(p:Point):Tile
		{
			return getTile(p.x, p.y);
		}
		
		public function init(data:BitmapData):void
		{
			_tilesX = data.width;
			_tilesY = data.height;
			
			_tileData = new Array(_tilesX);
			for (var i:int = 0; i < _tilesX; i++)
			{
				_tileData[i] = new Array(_tilesY);
				for (var j:int = 0; j < _tilesY; j++)
				{
					_tileData[i][j] = TileFactory.getTile(data.getPixel(i, j));
				}
			}
		}
		
		public function init2(data:BitmapData):void
		{
			if ((data.width == _tilesX) && (data.height == _tilesY))
			{
				var _yellows:int = 0;
				
				_objectsData = new Array(_tilesX);
				for (var i:int = 0; i < _tilesX; i++)
				{
					_objectsData[i] = new Array(_tilesY);
					for (var j:int = 0; j < _tilesY; j++)
					{
						var n:IRenderableObject = MapObjectFactory.getObject(data.getPixel(i, j));
						if (n != null)
						{
							_objectsData[i][j] = n;
							if (n is Mob)
							{
								(n as Mob).setPos(i * Tile.WIDTH, j * Tile.HEIGHT);
								addMob(n as Mob);
							}
							if (n is YellowThing)
								_yellows++;
							if (n is Player)
								_player = n as Player;
						}
					}
				}
				
				GameHUD.setYellowsCount(_yellows);
				GameHUD.showHints();
			}
			else
			{
				throw new Error("Invalid layer 2 size!");
			}
		}
		
		/* INTERFACE Game.IRenderableObject */
		
		public function render():BitmapData
		{
			_bitmapResult.fillRect(_bitmapResult.rect, 0x00000000);
			/*var mapWidth:Number = _tilesX * 32;
			var mapHeigh:Number = _tilesY * 32;
			
			_backMatrix.scale(mapWidth / _bmpBack.width, mapHeigh / _bmpBack.height);
			_bitmapResult.draw(_bmpBack, _backMatrix);*/
			
			if (_tileData != null)
			{
				for (var i:int = _topLeftTile.x; i < _topLeftTile.x + _countTileWidth; i++)
				{
					if ((i >= 0) && (i < _tileData.length))
					{
						for (var j:int = _topLeftTile.y; j < _topLeftTile.y + _countTileHeigh; j++)
						{
							if ((j >= 0) && (j < _tileData[i].length))
							{
								var t:Tile = _tileData[i][j];
								
								if (t != null)
								{
									_bitmapResult.copyPixels(t.render(), t.render().rect, new Point((i - _topLeftTile.x) * Tile.WIDTH - (_shiftX % Tile.WIDTH), (j - _topLeftTile.y) * Tile.HEIGHT - (_shiftY % Tile.HEIGHT)));
								}
							}
						}
					}
				}
			}
			
			var screenRect:Rectangle = new Rectangle(_shiftX, _shiftY, 640, 480);
			
			for (var k:int = 0; k < _mobs.length; k++)
			{
				var m:Mob = _mobs[k];
				if (screenRect.intersects(m.rect))
				{
					var mx:Matrix = new Matrix();
					
					mx.translate(m.center.x, m.center.y);
					if (m.rotation != 0)
					{
						trace(m.rotation);
						mx.rotate(m.rotation);
					}
					
					if (m.flipHorisontal)
					{
						mx.translate(-m.width, 0);
						mx.scale(-1, 1);
					}
					
					mx.translate(m.x - _shiftX, m.y - _shiftY);
					_bitmapResult.draw(m.render(), mx);
				}
			}
			
			return _bitmapResult;
		}
		
		public function update(deltaTime:Number):void
		{
			shiftX = _player.pos.x - 320;
			shiftY = _player.pos.y - 240;
			
			for (var i:int = 0; i < _mobs.length; i++)
			{
				_mobs[i].update(deltaTime);
			}
		}
		
		public function get shiftX():int
		{
			return _shiftX;
		}
		
		public function set shiftX(value:int):void
		{
			_shiftX = value;
			if (_shiftX < 0)
				_shiftX = 0;
			
			var maxsx:int = _tilesX * Tile.WIDTH - 640;
			if (_shiftX > maxsx)
				_shiftX = maxsx;
			
			_topLeftTile.x = Math.floor(_shiftX / Tile.WIDTH);
		}
		
		public function get shiftY():int
		{
			return _shiftY;
		}
		
		public function set shiftY(value:int):void
		{
			_shiftY = value;
			if (_shiftY < 0)
				_shiftY = 0;
			
			var maxsx:int = _tilesY * Tile.HEIGHT - 480;
			if (_shiftY > maxsx)
				_shiftY = maxsx;
			
			_topLeftTile.y = Math.floor(_shiftY / Tile.HEIGHT);
		}
		
		static public function get Instance():GameMap
		{
			if (_Instance == null)
				new GameMap();
			return _Instance;
		}
		
		public function get player():Player
		{
			return _player;
		}
	}
}