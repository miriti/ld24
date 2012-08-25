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
		static public const AIR_GRAVITY:Number = 15;
		static public const AIR_FRICTION:Number = 1;
		
		protected var _tileBitmap:BitmapData;
		protected var _gravity:Number = 0;
		protected var _friction:Number = 0;
		
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
		
		public function get gravity():Number 
		{
			return _gravity;
		}
		
		public function get friction():Number 
		{
			return _friction;
		}
	}

}