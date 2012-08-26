package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import Game.GameAnimSprite;
	import Game.GameHUD;
	import Game.GameMain;
	import Game.Input;
	import Game.Objects.DnaStrike;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Player extends Mob
	{
		private var _dnaStrike:DnaStrike = new DnaStrike();
		
		public function Player()
		{
			super(32, 13);
			_animations.push(new GameAnimSprite((new Assets.mobTest() as Bitmap).bitmapData, new Point(32, 13), 50));
			_currentAnimation = 0;
			_controlled = true;
			_health = 100;
			_healthMax = 100;
			
			_skillSwimming = 15;
			_skillWaterbreathing = 10;
			_skillWalking = 0;
			_skillAirBreathing = 0;
			
			_useWorldConsts = true;
			
			Input.addKeyboardHook(keyboardHook);
		}
		
		private function keyboardHook(keyCode:int):void
		{
			if (keyCode == Keyboard.SPACE)
			{
				if (GameHUD._dnasPicked > 0)
				{
					if (!_dnaStrike.acting)
					{
						GameHUD.dnasPickup(-1);
						_dnaStrike.fire();
					}
				}
			}
		}
		
		override public function update(deltaTime:Number):void
		{
			_dnaStrike.flipHorisontal = _flipHorisontal;
			if (!_flipHorisontal)
				_dnaStrike.setPos(x + width, y - 10);
			else
				_dnaStrike.setPos(x - _dnaStrike.width, y - 10);
			super.update(deltaTime);
		}
		
		override public function get health():Number
		{
			return super.health;
		}
		
		override public function set health(value:Number):void
		{
			if (value <= 0)
			{
				GameMain.Inst.gameOver();
			}
			else
			{
				super.health = value;
				GameHUD.health(_health, _healthMax);
			}
		}
		
		public function get dnaStrike():DnaStrike
		{
			return _dnaStrike;
		}
		
		override public function set skillFlying(value:Number):void
		{
			GameHUD.message("Flying skill +" + (value - _skillFlying).toString());
			if ((_skillFlying < 5) && (value >= 5))
				GameHUD.message("EVOLUTION: Now you can FLY!");
			super.skillFlying = value;
		}
		
		override public function get skillFlying():Number
		{
			return super.skillFlying;
		}
		
		override public function set skillAirBreathing(value:Number):void
		{
			GameHUD.message("Air breathing skill +" + (value - _skillAirBreathing).toString());
			if ((_skillAirBreathing < 5) && (value >= 5))
				GameHUD.message("EVOLUTION: Now you can breath with air!!");
			super.skillAirBreathing = value;
		}
		
		override public function get skillAirBreathing():Number
		{
			return super.skillAirBreathing;
		}
		
		override public function set skillJumping(value:Number):void
		{
			GameHUD.message("Jumping skill +" + (value - _skillJumping).toString());
			super.skillJumping = value;
		}
		
		override public function set skillWaterbreathing(value:Number):void
		{
			GameHUD.message("Water breathing skill +" + (value - _skillWaterbreathing).toString());
			super.skillWaterbreathing = value;
		}
		
		override public function get skillWaterbreathing():Number
		{
			return super.skillWaterbreathing;
		}
		
		override public function set skillWalking(value:Number):void
		{
			GameHUD.message("Walking skill +" + (value - _skillWalking).toString());
			if ((_skillWalking < 5) && (value >= 5))
				GameHUD.message("EVOLUTION: Now you can walk!");
			super.skillWalking = value;
		}
		
		override public function get skillWalking():Number
		{
			return super.skillWalking;
		}
		
		override public function set skillSwimming(value:Number):void
		{
			GameHUD.message("Swimming skill +" + (value - _skillSwimming).toString());
			super.skillSwimming = value;
		}
		
		override public function get skillSwimming():Number
		{
			return super.skillSwimming;
		}
	
	}

}