package Game.Tiles 
{
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class TileGround extends TileSolid 
	{
		
		public function TileGround(variant:int = 0) 
		{
			super(TileSet.getTileBitmap(0, variant));
		}
		
	}

}