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
	public class Pegeon extends Mob
	{
		private var _anim:GameAnimSprite;
		private var _initY:Number;
		private var _flyAway:Boolean = false;
		
		public function Pegeon()
		{
			super(32, 32);
			_anim = new GameAnimSprite((new Assets.mobPegeon() as Bitmap).bitmapData, new Point(width, height));
			_animations.push(_anim);
			_currentAnimation = 0;
			_anim.frameMax = 0;
		}
		
		override protected function dnaExtracting():void
		{
			GameMap.Instance.delMob(this);
			GameMap.Instance.player.skillFlying += Math.floor(Math.random() * 5);
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
			
			if ((Math.abs(p.x - x) < 200) && (Math.abs(p.y - _initY) < 200))
			{
				_flyAway = true;
				_anim.frameMax = 2;
			}
			else
				_flyAway = false;
			
			if (_flyAway)
			{
				if (y > _initY - 100)
				{
					y -= (deltaTime / 1000) * 50;
				}
				else
				{
					_flyAway = false;
				}
			}
			else
			{
				if (y < _initY)
				{
					y += (deltaTime / 1000) * 50;
					if (y >= _initY)
					{
						y = _initY;
						_anim.frameMax = 0;
					}
				}
			}
			
			super.update(deltaTime);
		}
	
	}

}