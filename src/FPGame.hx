package;

import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import haxepunk.graphics.Image;
import com.jacobalbano.cold.*;
import com.jacobalbano.humphrey.*;
import com.jacobalbano.punkutils.*;
import com.jacobalbano.slang3.*;
import com.jacobalbano.slang3.functions.*;
import flash.geom.Point;
import haxe.xml.Access;
import haxepunk.Engine;
import haxepunk.Entity;
import haxepunk.HXP;
import openfl.Assets;

class FPGame extends Engine
{
	public static var globalSlang(default, never):Scope = new Scope();
	private static var scriptEngine(default, never):ScriptEngine = new ScriptEngine();
	public static function compile(source:String, ?parentScope:Scope):Scope
	{
		if (parentScope == null) parentScope = globalSlang;
		return scriptEngine.compile(source, parentScope);
	}
	
    public function new()
    {
        super(800, 600, 60, true);
    }
    
    override public function init() : Void
    {
        super.init();
        
        bindFunctions();
        registerClasses();
        
        restart();
    }
    
    private function restart() : Void
    {   
        items = new Map();
        
        currentWorld = "";
        
        loadSettings();
    }
    
    private function loadSettings() : Void
    {
        var settings = new Access(Xml.parse(Assets.getText("config/settings.xml")).firstElement());
        
        try
        {
			FPGame.compile(settings.node.autoexec.innerData).execute();
        }
        catch (err)
        {
            trace(err);
        }
        
        loadWorld(settings.node.startWorld.innerData);
    }
    
    private function bindFunctions() : Void
    {
        globalSlang.setFunction(new NativeFunction("world", loadWorld, 1, Procedure, null, this));
        globalSlang.setFunction(new NativeFunction("lastWorld", getLastWorld, 0, Procedure, null, this));
        
        globalSlang.setFunction(new NativeFunction("rotateOverworld", (s : String) -> Overworld.rotateToZone(world, s), 1, Procedure, null, this));
		
		// polyfill
		globalSlang.setFunction(new NativeFunction("not", (x) -> !x, 1, Function));
		globalSlang.setFunction(new NativeFunction("both", (x, y) -> x && y, 2, Function));
		globalSlang.setFunction(new NativeFunction("either", (x, y) -> x || y, 2, Function));
		globalSlang.setFunction(new NativeFunction("anyEqual", (x, options:SlangArray) -> {
            for (o in options.array)
                if (x == o) return true;
            return false;
        }, 2, Function));
        
        //	log
        globalSlang.setFunction(new NativeFunction("print", (x:String) -> trace(x), 1, Procedure, null, this));
        
        //	inventory
        globalSlang.setFunction(new NativeFunction("hasItem?", hasItem, 1, Function, null, this));
        globalSlang.setFunction(new NativeFunction("collectItem", collectItem, 1, Procedure, null, this));
        globalSlang.setFunction(new NativeFunction("clearItems", clearItems, 0, Procedure, null, this));
        globalSlang.setFunction(new NativeFunction("direct", direct, 0, Procedure, null, this));
        globalSlang.setFunction(new NativeFunction("removeType", remove, 1, Procedure, null, this));
    }
    
    private function registerClasses() : Void
    {
        loader.addClass("Actor", Actor);
        loader.addClass("Ambiance", Ambiance);
        loader.addClass("Background", Background);
        loader.addClass("Boundary", Boundary);
        loader.addClass("CameraPan", TWDCameraPan);
        loader.addClass("Decal", Decal);
        loader.addClass("Director", Director);
        loader.addClass("FootstepSound", FootstepSound);
        loader.addClass("Hotspot", Hotspot);
        loader.addClass("Humphrey", Humphrey);
        loader.addClass("Script", Script);
        loader.addClass("Spinky", Spinky);
        loader.addClass("SmallHumphrey", SmallHumphrey);
        loader.addClass("Overworld", Overworld);
        loader.addClass("ParticleEmitter", ParticleEmitter);
        loader.addClass("Pickup", Pickup);
        loader.addClass("PlayerTrigger", PlayerTrigger);
        loader.addClass("Star", Star);
        loader.addClass("Subway", Subway);
        loader.addClass("WorldSound", WorldSound);
    }
    
    private function loadWorld(name : String) : Void
    {
        if (name == "" || transitioning)
            return;
        
        try
        {
            remove(Type.getClassName(PlayerTrigger));
            remove(Type.getClassName(Ambiance));
            var h = world.classFirst(Humphrey);
            if (h != null)
                h.active = false;
            
            var oWorld = loader.buildWorld('worlds/${name}/map.oel');
			oWorld.add(new Transition());

            var black = Image.createRect(HXP.width, HXP.height, 0x0, 0);
            black.scrollX = black.scrollY = 0;
            world.addGraphic(black).layer = -9001;

            HXP.tween(black, { alpha: 1 }, 1).onComplete.bind(() -> {
                transitioning = false;
                world = oWorld;
                lastWorld = currentWorld;
                currentWorld = name;
                Mouse.cursor = MouseCursor.ARROW;
            });
        
            transitioning = true;
        }
        catch (err)
        {
            trace("Failed to load world '" + name + "'");
            trace(err);
            transitioning = false;
            loadWorld(currentWorld);
        }
    }

    private var transitioning:Bool = false;
    
    //{ region helpers
    
    private function getLastWorld() : String
    {
        return lastWorld;
    }
    
    /**
		 * Slang function!
		 * Remove all entities of a named type from the world
		 * @param	s
		 */
    private function remove(s : String) : Void
    {
        var all:Array<Entity> = [];
        world.getAll(all);
        
        var type : String = s.toLowerCase();
        var name : String = "";
        
        for (item in all)
        {
            name = Type.getClassName(Type.getClass(item)).toLowerCase();
            if (name.indexOf(type) >= 0)
                world.remove(item);
        }
    }
    
    /**
		 * Start the director or directors in the world
		 */
    private function direct() : Void
    {
        var all : Array<Director> = [];
        world.getClass(Director, all);
        
        for (item in all)
            item.start();
    }
    //} endregion
    
    //{ region inventory
    private function hasItem(name : String) : Bool
    {
        return items.exists(name);
    }
    
    private function collectItem(name : String) : Void
    {
        items.set(name, true);
        
        var all : Array<Humphrey> = [];
        world.getClass(Humphrey, all);
        
        for (item in all)
            item.notifyOfItem(name);
    }
    
    private function clearItems() : Void
    {
        items = new Map();
    }

	public static function main() { new FPGame(); }
	
	private var loader:OgmoLoader = new OgmoLoader();
    private var currentWorld : String;
    private var lastWorld : String;
    private var items : Map<String, Bool>;
}