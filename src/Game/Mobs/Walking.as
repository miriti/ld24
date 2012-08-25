package Game.Mobs 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Walking extends Mob 
	{
		
		public function Walking() 
		{
			super(105, 32);
			_animations.push(new GameAnimSprite((new Assets.mobWalking() as Bitmap).bitmapData, new Point(105, 32)));
			_currentAnimation = 0;
		}
		
		override public function update(deltaTime:Number):void 
		{
			super.update(deltaTime);
		}
		
	}

}