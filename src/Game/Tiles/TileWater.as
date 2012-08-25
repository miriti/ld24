package Game.Tiles
{
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class TileWater extends Tile
	{
		
		public function TileWater(variant:int)
		{
			super(TileSet.getTileBitmap(1, variant));
			_gravity = 0;
			_friction = 10;
		}
	
	}

}