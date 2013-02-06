package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Star extends XMLEntity 
	{
		private var tweenIn:VarTween;
		private var tweenOut:VarTween;
		
		public function Star() 
		{
			graphic = Image.createCircle(1.5);
			
			tweenOut = new VarTween(fadeIn, ONESHOT);
			tweenIn = new VarTween(fadeOut, ONESHOT);
			
			fadeOut();
		}
		
		private function fadeOut():void
		{
			tweenOut.tween(graphic, "alpha", 0.9, 1 + FP.rand(10) / 10);
			addTween(tweenOut, true);
		}
		
		private function fadeIn():void
		{
			tweenIn.tween(graphic, "alpha", 0.1, 1 + FP.rand(10) / 10);
			addTween(tweenIn, true);
		}
		
	}

}