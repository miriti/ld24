package Game
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Snd
	{
		private static var _I:Snd;
		
		private var _sndColl:Dictionary = new Dictionary();
		
		public function Snd()
		{
			_sndColl["pickup"] = new Assets.sndPickup();
		}
		
		public function play(name:String, vol:Number = 1, pan:Number = 0):void
		{
			(_sndColl[name] as Sound).play(0, 0, new SoundTransform(vol, pan));
		}
		
		static public function get I():Snd
		{
			if (_I == null)
				_I = new Snd();
			return _I;
		}
	
	}

}