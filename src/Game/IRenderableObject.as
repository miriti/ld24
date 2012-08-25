package Game 
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public interface IRenderableObject 
	{
		function render():BitmapData;
		function update(deltaTime:Number):void;
	}
	
}