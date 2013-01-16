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
		
		public var typeName:String;
		
		public function Pickup() 
		{
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
			
			try 
			{
				var removeMe:Scope = new Scope(Game.instance.console.slang);
				removeMe.addFunction(new SlangFunction("removeMe", collected));
				
				removeMe.compile(
				"if hasItem? " + typeName + " {"
					+ "removeMe"
				+ "}").execute();
			} 
			catch (err:Error) 
			{
				
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
			var all:Array = [];
			world.getClass(Humphrey, all);
			
			if (all.length == 0)
			{
				return;
			}
			
			var humphrey:Humphrey = all[0];
			
			if (Point.distance(new Point(this.x, this.y), new Point(humphrey.x, humphrey.y)) > humphrey.width * 2)
			{
				return;
			}
			
			try 
			{
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
		
	}

}