package Game
{
	import Game.Objects.YellowThing;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class MapObjectFactory
	{
		static public function getObject(pixel:uint):IRenderableObject
		{
			switch (pixel)
			{
				case 0xffff00:
					return new YellowThing();
				default:
					return null;
			}
		}
	}

}