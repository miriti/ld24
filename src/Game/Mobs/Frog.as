package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameMap;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Frog extends Mob
	{
		private var _initX:Number;
		
		public function Frog()
		{
			super(32, 32);
			_animations.push(new GameAnimSprite((new Assets.mobFrog() as Bitmap).bitmapData, new Point(width, height)));
			_currentAnimation = 0;
			_useWorldConsts = true;
		}
		
		override protected function dnaExtracting():void
		{
			GameMap.Instance.player.skillJumping += Math.floor(5 * Math.random());
			GameMap.Instance.player.skillWalking += Math.floor(2 * Math.random());
			GameMap.Instance.delMob(this);
			super.dnaExtracting();
		}
		
		override public function setPos(nx:Number, ny:Number):Point
		{
			_initX = nx;
			return super.setPos(nx, ny);
		}
		
		override public function update(deltaTime:Number):void
		{
			
			super.update(deltaTime);
		}
	}

}