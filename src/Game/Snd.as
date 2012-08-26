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
			_I = this;
			_sndColl["pickup"] = new Assets.sndPickup();
			_sndColl["pickup-2"] = new Assets.sndPickup2();
			_sndColl["splash"] = new Assets.sndSplash();
			_sndColl["msg"] = new Assets.sndMsg();
			_sndColl["dna-hit"] = new Assets.sndDnaHit();
			_sndColl["hurt"] = new Assets.sndHurt();
		}
		
		public function play(name:String, vol:Number = 1, pan:Number = 0):void
		{
			(_sndColl[name] as Sound).play(0, 0, new SoundTransform(vol, pan));
		}
		
		static public function get I():Snd
		{
			if (_I == null)
				new Snd();
			return _I;
		}
	
	}

}