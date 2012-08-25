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
	public class YellowThing extends Mob
	{
		
		public function YellowThing()
		{
			super(32, 32);
			_animations.push(new GameAnimSprite((new Assets.objYellowThing() as Bitmap).bitmapData, new Point(32, 32)));
			_currentAnimation = 0;
		}
		
		override public function update(deltaTime:Number):void
		{
			var p:Player = GameMap.Instance.player;
			
			if ((Math.abs(y - p.y) <= 16) && (Math.abs(x - p.x) <= 16))
			{
				GameMap.Instance.delMob(this);
				Snd.I.play("pickup");
				GameHUD.yellowPickup(1);
			}
			super.update(deltaTime);
		}
	}
}