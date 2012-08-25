package Game.Tiles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class TileSet
	{
		private static var tilesetBitmap:Bitmap;
		private static var tiles:Array;
		
		public static function getTileBitmap(x:int, y:int):BitmapData
		{
			if (tilesetBitmap == null)
				tilesetBitmap = new Assets.tilesetMain;
			
			if (tiles == null)
				tiles = new Array();
			
			if (tiles[x] == null)
				tiles[x] = new Array();
			
			if (tiles[x][y] == null)
			{
				var newTileBitmap:BitmapData = new BitmapData(Tile.WIDTH, Tile.HEIGHT, true, 0x00000000);
				newTileBitmap.copyPixels(tilesetBitmap.bitmapData, new Rectangle(x * Tile.WIDTH, y * Tile.HEIGHT, Tile.WIDTH, Tile.HEIGHT), new Point(0, 0));
				tiles[x][y] = newTileBitmap;
			}
			
			return tiles[x][y];
		}
	}

}