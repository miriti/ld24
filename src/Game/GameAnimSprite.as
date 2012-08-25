package Game
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class GameAnimSprite implements IRenderableObject
	{
		protected var _fullBitmap:BitmapData;
		protected var _frames:Array = new Array();
		protected var _frameCurrent:int = 0;
		protected var _frameMax:int = 0;
		protected var _frameMin:int = 0;
		protected var _frameTimePassed:Number = 0;
		protected var _frameTime:Number;
		
		public function GameAnimSprite(animBitmap:BitmapData, frameSize:Point = null, frameTime:Number = 100)
		{
			_fullBitmap = animBitmap;
			_frameTime = frameTime;
			
			if (frameSize == null)
			{
				_frames[0] = _fullBitmap;
			}
			else
			{
				if ((animBitmap.width % frameSize.x == 0) && (animBitmap.height % frameSize.y == 0))
				{
					for (var i:int = 0; i < animBitmap.width / frameSize.x; i++)
					{
						for (var j:int = 0; j < animBitmap.height / frameSize.y; j++)
						{
							var newFrame:BitmapData = new BitmapData(frameSize.x, frameSize.y, true, 0x00000000);
							newFrame.copyPixels(_fullBitmap, new Rectangle(i * frameSize.x, j * frameSize.y, frameSize.x, frameSize.y), new Point(0, 0));
							_frames.push(newFrame);
						}
					}
					
					_frameMax = _frames.length - 1;
				}
				else
				{
					throw new Error("Bitmap have invalid size");
				}
			}
		}
		
		/* INTERFACE Game.IRenderableObject */
		
		public function render():BitmapData
		{
			return _frames[_frameCurrent];
		}
		
		public function update(deltaTime:Number):void
		{
			if (_frameTimePassed >= _frameTime)
			{
				_frameTimePassed = 0;
				_frameCurrent++;
				if (_frameCurrent > _frameMax)
					_frameCurrent = _frameMin;
			}
			else
				_frameTimePassed += deltaTime;
		}
	
	}

}