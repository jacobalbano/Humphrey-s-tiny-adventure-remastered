package com.jacobalbano.humphrey
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Humphrey extends XMLEntity 
	{
		private var velocity:Point;
		private var animation:Spritemap;
		static private const ZERO:Point = new Point();
		
		public var walkSpeed:Number;
		public var hasBackpack:Boolean;
		public var flipped:Boolean;
		
		private var lastAnimIndex:int;
		private var snowStepSounds:Array;
		
		public function Humphrey() 
		{	
			//	animation
			animation = new Spritemap(Library.getImage("art.characters.humphrey.png").bitmapData, 150, 200);
			graphic = animation;
			animation.centerOrigin();
			
			animation.add("stand", [0]);
			animation.add("stand-backpack", [8]);
			
			animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 10, true);
			animation.add("walk-backpack", [8, 9, 10, 11, 12, 13, 14, 15], 10, true);
			
			//	collision
			type = "humphrey";
			centerOrigin();
			setHitbox(50, 50, animation.width / 4, -50);
			
			//	input
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("up", Key.W, Key.UP);
			Input.define("down", Key.S, Key.DOWN);
			
			//	sounds
			snowStepSounds = [];
			for each (var item:XML in Library.getXML("Library.xml").sounds.sound) 
			{
				var name:String = new String(item).split("/").join(".");
				if (name.indexOf("footsteps-snow") >= 0)
				{
					snowStepSounds.push(Library.getSound(name));
				}
			}
			
			velocity = new Point();
		}
		
		override public function added():void 
		{
			super.added();
			animation.flipped = flipped;
		}
		
		override public function update():void 
		{	
			super.update();
			
			checkMovement();
			
			updateAnimation();
			
			playFootstepSound();
		}
		
		private function checkMovement():void 
		{
			velocity.x = velocity.y = 0;
			
			if (Input.check("left"))
			{
				velocity.x -= walkSpeed;
			}
			
			if (Input.check("right"))
			{
				velocity.x += walkSpeed;
			}
			
			if (Input.check("up"))
			{
				velocity.y -= walkSpeed;
			}
			
			if (Input.check("down"))
			{
				velocity.y += walkSpeed;
			}
			
			velocity.normalize(walkSpeed);
			moveBy(velocity.x, velocity.y, "boundary");
		}
		
		private function updateAnimation():void 
		{
			if (velocity.equals(ZERO))
			{
				if (hasBackpack)
				{
					animation.play("stand-backpack");
				}
				else
				{
					animation.play("stand");
				}
			}
			else
			{
				if (velocity.x > 0)
				{
					animation.flipped = false;
				}
				else if (velocity.x < 0)
				{
					animation.flipped = true;
				}
				
				if (hasBackpack)
				{
					animation.play("walk-backpack");
				}
				else
				{
					animation.play("walk");
				}
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean 
		{
			velocity.x = 0;
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity):Boolean 
		{
			velocity.y = 0;
			return super.moveCollideY(e);
		}
		
		public function notifyOfItem(name:String):void 
		{
			switch (name) 
			{
				case "backpack":
					hasBackpack = true;
					break;
				default:
					break;
			}
		}
		
		private function playFootstepSound():void 
		{
			if (animation.index != lastAnimIndex && animation.index % 4 == 0)
			{
				var s:Sfx = new Sfx(snowStepSounds[FP.rand(snowStepSounds.length)]);
				s.play(0.5);
			}
			
			lastAnimIndex = animation.index;
		}
		

	}
	
}