package  
{
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Assets 
	{
		// Maps
		[Embed(source="../assets/maps/test-map.png")]
		static public var mapTest:Class;
		
		// Mobs
		[Embed(source="../assets/mobs/test-mob.png")]
		static public var mobTest:Class;
		
		[Embed(source="../assets/mobs/dolphin/dolphin.png")]
		static public var mobDolphin:Class;
		
		// Tileset
		[Embed(source="../assets/map-tileset.png")]
		static public var tilesetMain:Class;
	}

}