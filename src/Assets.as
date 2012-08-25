package  
{
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Assets 
	{
		// Maps
		[Embed(source="../assets/maps/layer1-map.png")]
		static public var mapLayer1:Class;
		
		[Embed(source="../assets/maps/layer2-map.png")]
		static public var mapLayer2:Class;
		
		// objects 
		[Embed(source="../assets/yellow-thing.png")]
		static public var objYellowThing:Class;
		
		// Mobs
		[Embed(source="../assets/mobs/test-mob.png")]
		static public var mobTest:Class;
		
		[Embed(source="../assets/mobs/duck/duck.png")]
		static public var mobDuck:Class;
		
		[Embed(source="../assets/mobs/dolphin/dolphin.png")]
		static public var mobDolphin:Class;
		
		[Embed(source="../assets/mobs/walking/walking.png")]
		static public var mobWalking:Class;
		
		// Tileset
		[Embed(source="../assets/map-tileset.png")]
		static public var tilesetMain:Class;		
		
		// Sounds
		[Embed(source="../assets/snd/pickup.mp3")]
		static public var sndPickup:Class;
	}

}