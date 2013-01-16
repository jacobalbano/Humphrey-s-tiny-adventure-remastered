package com.jacobalbano.cold 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * @author Jake Albano
	 */
	public class Hotspot extends XMLEntity 
	{
		private var size:Point;
		private var contains:Boolean;
		public var onClick:String;
		public var onEnter:String;
		public var onExit:String;
		private var onClickCallback:Scope;
		private var onEnterCallback:Scope;
		private var onExitCallback:Scope;
		
		public function Hotspot() 
		{
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			size = new Point(entity.@width, entity.@height);
			
			try 
			{
				onClickCallback = new Scope(Game.instance.console.slang).compile(onClick);
				onEnterCallback = new Scope(Game.instance.console.slang).compile(onEnter);
				onExitCallback = new Scope(Game.instance.console.slang).compile(onExit);
			} 
			catch (err:Error) 
			{
				Game.instance.console.print(err.message);
			}
		}
		
		override public function removed():void 
		{
			super.removed();
			if (contains)
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
					callback(onClickCallback);
				}
				
				Mouse.cursor = MouseCursor.BUTTON;
			}
			
			if (lastContain != contains)
			{
				if (contains)
				{
					callback(onEnterCallback);
				}
				else
				{
					Mouse.cursor = MouseCursor.ARROW;
					callback(onExitCallback);
				}
			}
		}
		
		private function callback(scope:Scope):void 
		{
			try 
			{
				scope.execute();
			} 
			catch (err:Error) 
			{
				Game.instance.console.print(err.message);
				
			}
		}
		
	}

}