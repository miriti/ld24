package Game.Objects
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameMap;
	import Game.Mobs.Mob;
	import Game.Snd;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class DnaStrike extends Mob
	{
		static public const TIMER:Number = 500;
		private var _timer:Number = 0;
		private var _acting:Boolean = false;
		
		public function DnaStrike()
		{
			super(96, 32);
			_animations.push(new GameAnimSprite((new Assets.objDnaStrike() as Bitmap).bitmapData, new Point(width, height), 10));
			_currentAnimation = 0;
		}
		
		public function fire():void
		{
			if (!_acting)
			{
				Snd.I.play("dna-hit");
				_timer = 0;
				GameMap.Instance.addMob(this);
				_acting = true;
			}
		}
		
		override public function update(deltaTime:Number):void
		{
			if (_timer >= TIMER)
			{
				_acting = false;
				GameMap.Instance.delMob(this);
			}
			else
			{
				_timer += deltaTime;
			}
			super.update(deltaTime);
		}
		
		public function get acting():Boolean
		{
			return _acting;
		}
	
	}

}