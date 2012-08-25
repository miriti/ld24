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
			switch (pixel)
			{
				case 0:
					return new TileGround(0);
				case 0x111111:
					return new TileGround(1);
				case 0x222222:
					return new TileGround(2);
				case 0x333333:
					return new TileGround(3);
				case 0x0094FF:
					return new TileWater(0);
				case 0x7FC9FF:
					return new TileWater(1);
				default:
					return null;
			}
		}
	
	}

}