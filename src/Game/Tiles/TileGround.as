package Game.Tiles 
{
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class TileGround extends TileSolid 
	{
		static public const GROUND_FRICTION:Number = 5;
		
		public function TileGround(variant:int = 0) 
		{
			super(TileSet.getTileBitmap(0, variant));
		}
		
	}

}