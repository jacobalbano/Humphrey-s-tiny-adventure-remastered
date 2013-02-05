package com.jacobalbano.humphrey 
{
	import com.jacobalbano.slang.Scope;
	import com.jacobalbano.slang.SlangFunction;
	import net.flashpunk.graphics.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.display.Animation;
	import com.thaumaturgistgames.flakit.Library;
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
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			var scope:Scope = new Scope(Game.instance.console.slang);
			scope.addFunction(new SlangFunction("hasBalloon?", findBalloon).paramCount(1).self(this));
			scope.compile("hasBalloon? hasItem? \"balloon\"");
			scope.execute();
		}
		
		private function findBalloon(hasBalloon:Boolean):void
		{
			if (hasBalloon)
			{
				var balloon:Image = new Image(Library.getImage("art.characters.balloon.png").bitmapData);
				balloon.centerOO();
				balloon.originY = balloon.height;
				y -= balloon.height;
				graphic = balloon;
			}
			else
			{
				humphrey = new Humphrey();
				spritemap = humphrey.graphic as Spritemap;
				
				spritemap.scale = 0.1;
				spritemap.smooth = true;
				graphic = spritemap;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (humphrey != null)
			{
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
		}
		
		override public function added():void 
		{
			super.added();
			
			if (humphrey != null)
			{
				world.add(humphrey);
			}
		}
		
		override public function removed():void 
		{
			super.removed();
			
			if (humphrey != null)
			{
				world.remove(humphrey);
			}
		}
	}

}