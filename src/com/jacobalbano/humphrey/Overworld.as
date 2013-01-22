package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.OgmoWorld;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Overworld extends XMLEntity 
	{
		private var image:Image;
		static private const ROTATE_SPEED:Number = 0.5;
		
		public function Overworld() 
		{
			graphic = image = new Image(Library.getImage("art.backgrounds.overworld.png").bitmapData.clone());
			image.smooth = true;
			image.centerOrigin();
			
			centerOrigin();
			
			Input.define("up", Key.W, Key.UP);
			Input.define("down", Key.S, Key.DOWN);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("left", Key.A, Key.LEFT);
		}
		
		public static function rotateToZone(world:OgmoWorld, name:String):void
		{
			function find():Boolean
			{
				var all:Array = [];
				world.getClass(Overworld, all);
				
				for each (var item:Overworld in all) 
				{
					item.setZone(name);
					return true;
				}
				
				return false;
			}
			
			
			if (!find())
			{
				world.add(new DeferredCallback(find));
			}
		}
		
		private function setZone(name:String):void 
		{
			switch (name) 
			{
				case "woods":
					image.angle = 0;
					break;
				case "desert":
					image.angle = 90;
					break;
				case "snow":
					image.angle = 180;
					break;
				case "city":
					image.angle = 270;
					break;
				default:
					return;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.check("left"))
			{
				image.angle -= ROTATE_SPEED;
			}
			
			if (Input.check("right"))
			{
				image.angle += ROTATE_SPEED;
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
				return "woods-gate";
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