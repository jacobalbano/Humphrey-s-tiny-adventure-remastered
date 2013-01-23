package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import com.jacobalbano.punkutils.Image;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Thought extends XMLEntity 
	{
		private var actor:Actor;
		private var seconds:int;
		private var ticks:int;
		
		public function Thought(actor:Actor, seconds:int, thought:String) 
		{
			this.seconds = seconds * 60;
			this.actor = actor;
			
			var image:Image = new Image(Library.getImage("art.thoughts." + thought + ".png"));
			image.alpha = 0;
			image.centerOO();
			graphic = image;
			
			var tween:VarTween = new VarTween(null, Tween.ONESHOT);
			tween.tween(graphic, "alpha", 1, 0.5);
			addTween(tween, true);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (actor)
			{
				x = actor.x;
				y = actor.y;
			}
			
			if (++ticks > seconds)
			{
				var tween:VarTween = new VarTween(remove, Tween.ONESHOT);
				tween.tween(graphic, "alpha", 0, 0.5);
				addTween(tween, true);
			}
		}
		
		private function remove():void 
		{
			actor = null;
			world.remove(this);
		}
		
	}

}