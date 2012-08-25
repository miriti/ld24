package Game
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import Game.Mobs.Mob;
	import Game.Mobs.Player;
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
		
		private var _bitmapResult:BitmapData = new BitmapData(640, 480, true, 0x00000000);
		private var _tileData:Array;
		
		private var _tilesX:int = 0;
		private var _tilesY:int = 0;
		
		private var _shiftX:int = 0;
		private var _shiftY:int = 0;
		
		private var _topLeftTile:Point = new Point(0, 0);
		private var _countTileWidth:int = 21;
		private var _countTileHeigh:int = 16;
		
		private var _mobs:Vector.<Mob> = new Vector.<Mob>();
		private var _player:Player = new Player();
		
		public function GameMap()
		{
			if (_Instance != null)
				throw new Error("Do not use constructor! Use GameMap.Instance to get an instance");
		}
		
		public function canPass(x:int, y:int):Boolean
		{
			if ((x >= 0) && (x < _tilesX) && (y >= 0) && (y < _tilesY))
			{
				return ((_tileData[x][y] == null) || ((_tileData[x][y] != null) && (!(_tileData[x][y] is TileSolid))));
			}
			else
			{
				trace(x, y, 'out');
				return false;
			}
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
			
			_mobs.push(_player);
		}
		
		/* INTERFACE Game.IRenderableObject */
		
		public function render():BitmapData
		{
			_bitmapResult.fillRect(_bitmapResult.rect, 0x00000000);
			
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
			
			for (var k:int = 0; k < _mobs.length; k++)
			{
				var m:Mob = _mobs[k];
				_bitmapResult.copyPixels(m.render(), m.render().rect, new Point(m.pos.x - _shiftX, m.pos.y - _shiftY));
			}
			return _bitmapResult;
		}
		
		public function update(deltaTime:Number):void
		{
			if (Input.isRight())
				_player.x += 5;
			
			if (Input.isLeft())
				_player.x -= 5;
			
			if (Input.isUp())
				_player.y -= 5;
			
			if (Input.isDown())
				_player.y += 5;
			
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
				_Instance = new GameMap();
			return _Instance;
		}
	
	}

}