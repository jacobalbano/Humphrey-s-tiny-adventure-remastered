package  
{
	import com.jacobalbano.cold.*;
	import com.jacobalbano.humphrey.*;
	import com.jacobalbano.punkutils.*;
	import com.jacobalbano.slang.SlangFunction;
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Dictionary;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	
	/**
	 * @author Jacob Albano
	 */
	
	public class FPGame extends Engine 
	{
		private var oWorld:OgmoWorld;
		
		private var currentWorld:String;
		private var lastWorld:String;
		
		private var items:Dictionary;
		
		public function FPGame() 
		{
			super(800, 600);
		}
		
		override public function init():void 
		{
			super.init();
			
			FP.world = oWorld = new OgmoWorld();
			
			bindFunctions();
			registerClasses();
			
			restart();
		}
		
		private function restart():void 
		{
			CONFIG::debug {
				FP.console.enable();
				FP.console.toggleKey = Key.F1;
			}
			
			items = new Dictionary();
			
			currentWorld = "";
			loadWorld(Library.getXML("config.settings.xml").startWorld);
			
			Game.instance.onReload = reload;
		}
		
		private function bindFunctions():void 
		{
			//	world
			Game.instance.console.slang.addFunction(
			new SlangFunction("world", loadWorld)
			.paramCount(1)
			.documentation("Load a world from an Ogmo level in a named folder")
			.self(this)
			);
			
			Game.instance.console.slang.addFunction(
			new SlangFunction("lastWorld", getLastWorld)
			.documentation("Return the name of the previous world")
			.self(this)
			);
			
			Game.instance.console.slang.addFunction(
			new SlangFunction("rotateOverworld", function (s:String):void { Overworld.rotateToZone(oWorld, s); } )
			.documentation("Set the zone of the overworld")
			.paramCount(1)
			.self(this)
			);
			
			//	log
			Game.instance.console.slang.addFunction(
			new SlangFunction("print", log)
			.paramCount(1)
			.documentation("Print a string to the console and log it with trace()")
			.self(this)
			);
			
			//	inventory
			Game.instance.console.slang.addFunction(
			new SlangFunction("hasItem?", hasItem)
			.paramCount(1)
			.documentation("Return whether Humphrey has collected an item")
			.self(this)
			);
			
			Game.instance.console.slang.addFunction(
			new SlangFunction("collectItem", collectItem)
			.paramCount(1)
			.documentation("Give an item to Humphrey")
			.self(this)
			);
		}
		
		private function registerClasses():void
		{	
			oWorld.addClass("Actor", Actor);
			oWorld.addClass("Ambiance", Ambiance);
			oWorld.addClass("Background", Background);
			oWorld.addClass("Boundary", Boundary);
			oWorld.addClass("CameraPan", TWDCameraPan);
			oWorld.addClass("Decal", Decal);
			oWorld.addClass("Director", Director);
			oWorld.addClass("FootstepSound", FootstepSound);
			oWorld.addClass("Hotspot", Hotspot);
			oWorld.addClass("Humphrey", Humphrey);
			oWorld.addClass("Script", Script);
			oWorld.addClass("SmallHumphrey", SmallHumphrey);
			oWorld.addClass("Overworld", Overworld);
			oWorld.addClass("ParticleEmitter", ParticleEmitter);
			oWorld.addClass("Pickup", Pickup);
			oWorld.addClass("PlayerTrigger", PlayerTrigger);
			oWorld.addClass("WorldSound", WorldSound);
		}
		
		private function getLastWorld():String
		{
			return lastWorld;
		}
		
		private function hasItem(name:String):Boolean
		{
			return items[name];
		}
		
		private function collectItem(name:String):void 
		{
			items[name] = true;
			
			var all:Array = [];
			oWorld.getClass(Humphrey, all);
			
			for each (var item:Humphrey in all) 
			{
				item.notifyOfItem(name);
			}
		}
		
		private function loadWorld(name:String):void 
		{
			if (name == "")
			{
				return;
			}
			
			try
			{
				oWorld.buildWorld("worlds." + name + ".map.oel");
			}
			catch (err:Error)
			{
				log("Failed to load world '" + name + "'");
				log(err.getStackTrace());
				loadWorld(currentWorld);
				return;
			}
			
			lastWorld = currentWorld;
			currentWorld = name;
			
			oWorld.add(new Transition);
		}
		
		//{ region helpers
		private function log(s:String):void
		{
			Game.instance.console.print(s);
			trace(s);
		}
		
		private function reload():void 
		{
			loadWorld(currentWorld);
		}
		//} endregion
		
	}

}