package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Overworld extends XMLEntity 
	{
		private var image:Image;
		
		public function Overworld() 
		{
			graphic = image = new Image(Library.getImage("art.backgrounds.overworld.png").bitmapData);
			image.smooth = true;
			image.centerOrigin();
			
			centerOrigin();
			
			Input.define("up", Key.W, Key.UP);
			Input.define("down", Key.S, Key.DOWN);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("left", Key.A, Key.LEFT);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.check("left"))
			{
				image.angle -= 1;
			}
			
			if (Input.check("right"))
			{
				image.angle += 1;
			}
			
			if (Input.check("up") || Input.check("down"))
			{
				var scope:Scope = new Scope(Game.instance.console.slang);
				
				try 
				{
					scope.compile("world " + getZone()).execute();
				} 
				catch (err:Error) 
				{
					trace(err.getStackTrace());
				}
			}
		}
		
		private function getZone():String 
		{
			var position:int = image.angle % 360;
			position = position < 0 ? position + 360 : position
			
			function between(i1:int, i2:int):Boolean
			{
				return position >= i1 && position <= i2;
			}
			
			if (between(315, 360) || between(0, 35))
			{
				return "woods-hub";
			}
			
			if (between(215, 315))
			{
				return "city-hub";
			}
			
			if (between(35, 125))
			{
				return "desert-hub";
			}
			
			return "snow-hub";
		}
		
	}

}