package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Subway extends XMLEntity 
	{
		public var flipped:Boolean;
		
		public function Subway() 
		{
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			var image:Image = new Image(Library.getImage("art.decals.train.png"));
			image.flipped = flipped;
			graphic = image;
			
			for each (var item:XML in entity.node) 
			{
				var to:Point = new Point(item.@x, item.@y);
				var tween:MultiVarTween = new MultiVarTween();
				tween.tween(this, { x : to.x, y : to.y }, 1.9, Ease.expoInOut);
				addTween(tween, true);
				break;	//	only use one node
			}
			
			var arrive:Sfx = new Sfx(Library.getSound("sounds.subway.mp3"));
			arrive.play(2, flipped ? 0.8 : -0.8);
		}
		
	}

}