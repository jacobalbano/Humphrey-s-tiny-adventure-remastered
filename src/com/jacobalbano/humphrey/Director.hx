package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.slang3.Scope;
import com.jacobalbano.slang3.functions.NativeFunction;
import openfl.Assets;

/**
	 * ...
	 * @author Jake Albano
	 */
class Director extends XMLEntity
{
    public var script : String;
    public var autostart : Bool;
    
    private var cues : Map<String, Bool>;
    private var actors : Array<Actor>;
    private var actorsFinished : Array<Actor>;
    private var scope : Scope;
    private var openRoles : Array<Dynamic>;
    private var isDirecting : Bool;
    
    
    public function new()
    {
        super();
        actors = [];
        actorsFinished = [];
        openRoles = [];
        
        isDirecting = false;
        
        scope = new Scope(FPGame.globalSlang);
        scope.setFunction(new NativeFunction("fill-role", fillRole, 2, Procedure, null, this));
    }
    
    override public function added() : Void
    {
        super.added();
        
        if (autostart)
        {
            start();
        }
    }
    
    /**
		 * Instruct an actor to load a script for this role
		 * @param	actor		The actor's name
		 * @param	scriptName	The name of the script file
		 */
    public function fillRole(actor : String, scriptName : String) : Void
    {
        for (item in actors)
        {
            if (item.name == actor)
            {
                item.loadRole(scriptName);
                return;
            }
        }
        
        openRoles.push([actor, scriptName]);
    }
    
    /**
		 * Find whether a cue has been given
		 * @param	name	The name or identifier of the cue
		 * @return	whether a cue has been given
		 */
    public function hasCue(name : String) : Bool
    {
        return cues.exists(name);
    }
    
    /**
		 * Alert other actors of a cue
		 * @param	name	The name or identifier of the cue
		 */
    public function giveCue(name : String) : Void
    {
        cues.set(name, true);
    }
    
    /**
		 * Adds an actor the active list
		 * @param	actor	The actor to add
		 */
    public function addActor(actor : Actor) : Void
    {
        actors.push(actor);
        checkRoles(actor);
    }
    
    private function checkRoles(actor : Actor) : Void
    {
        if (openRoles.length > 0)
        {
            var i : Int = 0;
            while (i < openRoles.length)
            {
                var item : Array<Dynamic> = openRoles[i];
                
                if (item[0] == actor.actorName)
                {
                    actor.loadRole(item[1]);
                    openRoles.splice(i, 1);
                    return;
                }
                ++i;
            }
        }
    }
    
    public function start() : Void
    {
        if (isDirecting)
        {
            return;
        }
        
        actorsFinished = [];
        cues = new Map();
		var src = Assets.getText('scripts/${script}.xml');
		var xml = Xml.parse(src);
        FPGame.compile(xml.firstElement().firstChild().nodeValue, scope).execute();
        
        for (actor in actors)
        {
            checkRoles(actor);
        }
        
        isDirecting = true;
    }
    
    public function onActorFinished(actor : Actor) : Void
    {
        if (Lambda.indexOf(actorsFinished, actor) < 0)
        {
            actorsFinished.push(actor);
            
            if (actorsFinished.length == actors.length)
            {
                isDirecting = false;
            }
        }
    }
}

