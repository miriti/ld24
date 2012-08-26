package Game
{
	import Game.Mobs.Duck;
	import Game.Mobs.Frog;
	import Game.Mobs.JellyFish;
	import Game.Mobs.Pegeon;
	import Game.Mobs.Player;
	import Game.Objects.DnaExtractor;
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
				case 0xffffff:
					return new Player();
				case 0xffff00:
					return new YellowThing();
				case 0x404040:
					return new Duck();
				case 0x0026FF:
					return new JellyFish();
				case 0xFF00FF:
					return new DnaExtractor();
				case 0x008000:
					return new Frog();
				case 0x7F3F3F:
					return new Pegeon();
				default:
					return null;
			}
		}
	}

}