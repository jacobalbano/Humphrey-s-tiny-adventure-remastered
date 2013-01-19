package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.display.Animation;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class SmallHumphrey extends XMLEntity 
	{
		private var humphrey:Humphrey;
		private var spritemap:Spritemap;
		
		public function SmallHumphrey() 
		{
			humphrey = new Humphrey();
			spritemap = humphrey.graphic as Spritemap;
			
			spritemap.scale = 0.1;
			spritemap.smooth = true;
		}
		
		override public function update():void 
		{
			super.update();
			
			humphrey.x = x;
			humphrey.y = y;
			
			if (Input.check("left"))
			{
				spritemap.flipped = true;
			}
			
			if (Input.check("right"))
			{
				spritemap.flipped = false;
			}
		}
		
		override public function added():void 
		{
			super.added();
			
			world.add(humphrey);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			world.remove(humphrey);
		}
	}

}