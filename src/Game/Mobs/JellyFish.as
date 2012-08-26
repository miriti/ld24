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
	public class JellyFish extends Mob
	{
		private var _sinPhase:Number = 0;
		private var _initY:Number;
		
		public function JellyFish()
		{
			super(32, 64);
			_animations.push(new GameAnimSprite((new Assets.mobJellyFish() as Bitmap).bitmapData, new Point(32, 64)));
			_currentAnimation = 0;
			_sinPhase = Math.random() * (Math.PI * 4);
			_skillWaterbreathing = 3;
			_skillSwimming = 4;
		}
		
		override protected function dnaExtracting():void 
		{
			GameMap.Instance.player.skillWaterbreathing += Math.floor(_skillWaterbreathing * Math.random());
			GameMap.Instance.player.skillSwimming += Math.floor(_skillSwimming * Math.random());
			GameMap.Instance.delMob(this);
			super.dnaExtracting();
		}
		
		override public function setPos(nx:Number, ny:Number):Point
		{
			_initY = ny;
			return super.setPos(nx, ny);
		}
		
		override public function update(deltaTime:Number):void
		{
			var p:Player = GameMap.Instance.player;
			y = _initY + Math.sin(_sinPhase) * 75;
			_sinPhase += (Math.PI / 6) * (deltaTime / 1000);
			
			if (p.rect.intersects(rect))
				p.health -= 0.5;
			
			super.update(deltaTime);
		}
	
	}

}