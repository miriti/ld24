package Game.Tiles
{
	import flash.display.BitmapData;
	import Game.IRenderableObject;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Tile implements IRenderableObject
	{
		public static const WIDTH:int = 32;
		public static const HEIGHT:int = 32;
		
		protected var _tileBitmap:BitmapData;
		protected var _fricton:Number;
		
		public function Tile(tileBitmap:BitmapData)
		{
			_tileBitmap = tileBitmap;
		}
		
		public function render():BitmapData
		{
			return _tileBitmap;
		}
		
		public function update(deltaTime:Number):void
		{
		
		}
	}

}