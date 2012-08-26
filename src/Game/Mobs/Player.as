package Game.Mobs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		
		private var _anim0:GameAnimSprite;
		private var _animW:GameAnimSprite;
		private var _animF:GameAnimSprite;
		
		private var _renderData:BitmapData = new BitmapData(32, 32);
		
		public function Player()
		{
			super(32, 13);
			_anim0 = new GameAnimSprite((new Assets.mobPlayerEv0() as Bitmap).bitmapData, new Point(32, 13), 50);
			_animW = new GameAnimSprite((new Assets.mobPlayerEvW() as Bitmap).bitmapData, new Point(32, 20));
			_animF = new GameAnimSprite((new Assets.mobPlayerEvF() as Bitmap).bitmapData, new Point(32, 13));
			_animF.frameMax = 0;
			//_animW
			//_animations.push();
			//_currentAnimation = 0;
			_controlled = true;
			_health = 100;
			_healthMax = 100;
			
			_skillSwimming = 15;
			_skillWaterbreathing = 10;
			_skillWalking = 0;
			_skillAirBreathing = 0;
			_skillFlying = 0;
			
			_useWorldConsts = true;
			
			Input.addKeyboardHook(keyboardHook);
		}
		
		override public function render():BitmapData
		{
			_renderData.fillRect(_renderData.rect, 0x00000000);
			_renderData.draw(_anim0.render());
			if (_skillWalking >= 5)
				_renderData.draw(_animW.render());
			
			if (_skillFlying >= 1)
				_renderData.draw(_animF.render());
			return _renderData;
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
			
			if (_mode != MODE_FLYING)
			{
				if ((keyCode == Keyboard.UP) || (keyCode == Keyboard.W))
				{
					if (_inJump)
					{
						if (_skillFlying >= 1)
							mode = MODE_FLYING;
					}
				}
			}
		}
		
		override public function get mode():int
		{
			return super.mode;
		}
		
		override public function set mode(value:int):void
		{
			if (value == MODE_FLYING)
				_animF.frameMax = 1;
			if ((mode == MODE_FLYING) && (value != MODE_FLYING))
				_animF.frameMax = 0;
			super.mode = value;
		}
		
		override public function update(deltaTime:Number):void
		{
			_dnaStrike.flipHorisontal = _flipHorisontal;
			if (!_flipHorisontal)
				_dnaStrike.setPos(x + width, y - 10);
			else
				_dnaStrike.setPos(x - _dnaStrike.width, y - 10);
			
			_anim0.update(deltaTime);
			_animW.update(deltaTime);
			_animF.update(deltaTime);
			super.update(deltaTime);
			
			if (_xSpeed == 0)
				_animW.frameMax = 0;
			else
				_animW.frameMax = 2;
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
			if ((_skillFlying < 1) && (value >= 1))
			{
				GameHUD.message("EVOLUTION: Now you can FLY!");
				GameHUD.message("HINT: Press [W] or [UP] while jumping to start fly!");
			}
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
			{
				GameHUD.message("EVOLUTION: Now you can walk!");
				_height = 20;
			}
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