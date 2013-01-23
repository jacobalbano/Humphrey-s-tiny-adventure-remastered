package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.jacobalbano.slang.SlangFunction;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Pickup extends XMLEntity 
	{
		private var contains:Boolean;
		private var scope:Scope;
		private var humphrey:Humphrey;
		private var actor:Actor;
		
		public var typeName:String;
		
		public function Pickup() 
		{
			actor = new Actor();
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			var image:Image = new Image(Library.getImage("art.pickups." + typeName + ".png"));
			
			setHitbox(image.width, image.height);
			centerOrigin();
			image.centerOrigin();
			graphic = image;
			
			scope = new Scope(Game.instance.console.slang);
			scope.compile("collectItem " + typeName);
		}
		
		override public function added():void 
		{
			super.added();
			
			world.add(actor);
			
			locateHumphrey();
			
			try 
			{
				var removeMe:Scope = new Scope(Game.instance.console.slang);
				removeMe.addFunction(new SlangFunction("removeMe", collected));
				
				removeMe.compile(
				"if hasItem? " + typeName + " {"
					+ "collectItem " + typeName + " "
					+ "removeMe"
				+ "}").execute();
			} 
			catch (err:Error) 
			{
				trace(err.getStackTrace());
			}
		}
		
		override public function removed():void 
		{
			super.removed();
			
			world.remove(actor);
			
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				Mouse.cursor = MouseCursor.ARROW;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			var lastContain:Boolean = contains;
			contains = collidePoint(x, y, world.mouseX, world.mouseY);
			
			if (contains)
			{
				if (Input.mouseReleased)
				{
					onClick();
				}
				
				Mouse.cursor = MouseCursor.BUTTON;
			}
			
			if (lastContain != contains)
			{
				if (!contains)
				{
					Mouse.cursor = MouseCursor.ARROW;
				}
			}
		}
		
		private function onClick():void 
		{
			locateHumphrey();
			
			if (humphrey == null)
			{
				return;
			}
			
			var here:Point = new Point(this.x, this.y);
			var there:Point = new Point(humphrey.x, humphrey.y);
			var distance:Number = Point.distance(here, there);
			
			if (distance > humphrey.width * 4)
			{
				return;
			}
			
			try
			{
				var all:Array = [];
				world.getClass(Director, all);
				
				for each (var item:Director in all) 
				{
					item.giveCue(typeName);
					break;
				}
				
				scope.execute();
				
				var tween:VarTween = new VarTween(collected, Tween.ONESHOT);
				tween.tween(graphic, "alpha", 0, 0.5, Ease.expoOut);
				addTween(tween, true);
			} 
			catch (err:Error) 
			{
				trace(err.getStackTrace());
			}
		}
		
		private function collected():void 
		{
			if (world)
			{
				world.remove(this);
			}
		}
		
		private function locateHumphrey():void
		{
			if (humphrey != null)
			{
				return;
			}
			
			var all:Array = [];
			world.getClass(Humphrey, all);
			
			if (all.length == 0)
			{
				return;
			}
			
			humphrey = all[0];
		}
		
	}

}