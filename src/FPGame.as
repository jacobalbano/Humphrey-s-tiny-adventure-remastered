package  
{
	import com.jacobalbano.cold.*;
	import com.jacobalbano.humphrey.Boundary;
	import com.jacobalbano.punkutils.*;
	import com.jacobalbano.slang.Scope;
	import com.jacobalbano.slang.SlangFunction;
	import com.thaumaturgistgames.flakit.Library;
	import com.jacobalbano.humphrey.Humphrey;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	
	/**
	 * @author Jacob Albano
	 */
	
	public class FPGame extends Engine 
	{
		private var oWorld:OgmoWorld;
		private var lastWorld:String;
		
		public function FPGame() 
		{
			super(800, 600);
		}
		
		override public function init():void 
		{
			super.init();
			
			bindFunctions();
			
			FP.world = oWorld = new OgmoWorld();
			FP.console.enable();
			FP.console.toggleKey = Key.F1;
			
			registerClasses();
			
			lastWorld = "";
			
			loadWorld("start");
			
			Game.instance.onReload = reload;
		}
		
		private function bindFunctions():void 
		{
			/**
			 * World
			 */
			Game.instance.console.slang.addFunction(
			new SlangFunction("world", loadWorld)
			.paramCount(1)
			.documentation("Load a world from an Ogmo level in a named folder")
			.self(this)
			);
			
			Game.instance.console.slang.addFunction(
			new SlangFunction("print", log)
			.paramCount(1)
			.documentation("Print a string to the console and log it with trace()")
			.self(this)
			);
		}
		
		private function registerClasses():void
		{
			oWorld.addClass("Ambiance", Ambiance);
			oWorld.addClass("Background", Background);
			oWorld.addClass("CameraPan", CameraPan);
			oWorld.addClass("Decal", Decal);
			oWorld.addClass("Hotspot", Hotspot);
			oWorld.addClass("Humphrey", Humphrey);
			oWorld.addClass("ParticleEmitter", ParticleEmitter);
			oWorld.addClass("WorldSound", WorldSound);
			oWorld.addClass("Boundary", Boundary);
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
				loadWorld(lastWorld);
				return;
			}
			
			lastWorld = name;
			
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
			loadWorld(lastWorld);
		}
		//} endregion
		
	}

}