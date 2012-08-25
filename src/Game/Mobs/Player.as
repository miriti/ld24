package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Player extends Mob
	{
		
		public function Player()
		{
			_animations.push(new GameAnimSprite((new Assets.mobTest() as Bitmap).bitmapData, new Point(32, 32), 500));
			_currentAnimation = 0;
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
		}
	
	}

}