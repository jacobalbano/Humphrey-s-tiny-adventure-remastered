package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.tweens.motion.QuadPath;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Spinky extends XMLEntity 
	{	
		public var isSad:Boolean;
		
		private static const FACE_LEFT:Boolean = false;
		private static const FACE_RIGHT:Boolean = true;
		
		private var spritemap:Spritemap;
		private var actor:Actor;
		private var facing:Boolean;
		
		public function Spinky() 
		{
			spritemap = new Spritemap(Library.getImage("art.characters.spinky.png").bitmapData, 100, 100);
			spritemap.add("happy", [0]);
			spritemap.add("sad", [1]);
			spritemap.add("sad-bag", [2]);
			spritemap.centerOrigin();
			spritemap.originY = spritemap.height;
			graphic = spritemap;
			setHitboxTo(graphic);
			centerOrigin();
			originY = spritemap.height;
			
			actor = new Actor();
			actor.actorName = "spinky";
			actor.messageResponse("hopForward", hopForward);
			actor.messageResponse("hopInPlace", hopInPlace);
			actor.messageResponse("turn", turn);
			actor.messageResponse("getHappy", getHappy);
			actor.messageResponse("getSad", getSad);
			actor.messageResponse("getBag", getBag);
			actor.messageResponse("fade", fade);
			
			facing = FACE_LEFT;
		}
		
		override public function added():void 
		{
			super.added();
			world.add(actor);
		}
		
		override public function removed():void 
		{
			super.removed();
			world.remove(actor);
		}
		
		override public function update():void 
		{
			super.update();
			actor.x = x;
			actor.y = y;
		}
		
		//{ region message responses
		
		private function fade():void 
		{
			var tween:VarTween = new VarTween(null, ONESHOT);
			tween.tween(graphic, "alpha", 0, 0.5, Ease.quadIn);
			addTween(tween, true);
		}
		
		private function getHappy():void 
		{
			spritemap.play("happy");
			isSad = false;
		}
		
		private function getSad():void 
		{
			spritemap.play("sad");
			isSad = true;
		}
		
		private function getBag():void
		{
			spritemap.play("sad-bag");
		}
		
		private function turn():void 
		{
			facing = !facing;
			spritemap.flipped = facing;
		}
		
		private function hopForward():void 
		{
			hop(false);
		}
		
		private function hopInPlace():void 
		{
			hop(true);
		}
		
		//} endregion
		
		private function hop(inPlace:Boolean):void 
		{
			var toward:int = facing == FACE_LEFT ? 1 : -1;
			var speed:int = isSad ? 20 : 50;
			
			var motion:QuadPath = new QuadPath(squish, ONESHOT);
			
			if (inPlace)
			{
				motion.addPoint(x, y);
				motion.addPoint(x, y - speed);
				motion.addPoint(x, y);
				motion.setMotion(0.25);
				motion.object = this;
			}
			else
			{
				motion.addPoint(x, y);
				motion.addPoint(x - (speed * toward), y - speed);
				motion.addPoint(x - ((speed + speed / 2) * toward), y);
				motion.setMotion(0.25);
				motion.object = this;
			}
			
			addTween(motion, true);
			
			var self:Spinky = this;
			function squish():void
			{
				var tween:VarTween = new VarTween(grow, ONESHOT);
				tween.tween(graphic, "scaleY", 0.7, 0.05);
				addTween(tween, true);
			}
			
			function grow():void
			{
				var tween:VarTween = new VarTween(null, ONESHOT);
				tween.tween(graphic, "scaleY", 1, 0.1);
				addTween(tween, true);
			}
			
		}
	}

}