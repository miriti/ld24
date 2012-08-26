package Game.Objects
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Game.GameAnimSprite;
	import Game.GameHUD;
	import Game.GameMap;
	import Game.Mobs.Mob;
	import Game.Mobs.Player;
	import Game.Snd;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class DnaExtractor extends Mob
	{
		private var _initY:Number;
		private var _sinPhase:Number = 0;
		private var _initX:Number;
		
		public function DnaExtractor()
		{
			super(32, 32);
			_animations.push(new GameAnimSprite((new Assets.objDnaExtractor() as Bitmap).bitmapData, new Point(width, height)));
			_currentAnimation = 0;
		}
		
		override public function setPos(nx:Number, ny:Number):Point
		{
			_initY = ny;
			_initX = nx;
			return super.setPos(nx, ny);
		}
		
		override public function update(deltaTime:Number):void
		{
			y = _initY + Math.sin(_sinPhase) * 3;
			x = _initX + Math.cos(_sinPhase) * 3;
			_sinPhase += (Math.PI / 16) + (deltaTime / 1000);
			var p:Player = GameMap.Instance.player;
			if (p.rect.intersects(rect))
			{
				GameMap.Instance.delMob(this);
				Snd.I.play("pickup-2");
				GameHUD.dnasPickup(1);
			}
			super.update(deltaTime);
		}
	
	}

}