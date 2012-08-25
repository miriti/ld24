package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameHUD;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Player extends Mob
	{
		
		public function Player()
		{
			super(32, 32);
			_animations.push(new GameAnimSprite((new Assets.mobTest() as Bitmap).bitmapData, new Point(32, 32), 50));
			_currentAnimation = 0;
			_controlled = true;
			_health = 100;
			_healthMax = 100;
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
		}
		
		override public function get health():Number 
		{
			return super.health;
		}
		
		override public function set health(value:Number):void 
		{
			super.health = value;
			GameHUD.health(_health, _healthMax);
		}
	
	}

}