package Game.Tiles 
{
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class TileFactory 
	{
		static public function getTile(pixel:uint):Tile 
		{
			switch (pixel) {
				case 0:
					return new TileGround();
				case 0x0094FF:
					return new TileWater();
				default:
					return null;
			}			
		}
		
	}

}