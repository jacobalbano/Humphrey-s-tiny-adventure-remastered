package com.jacobalbano.humphrey;

import haxe.Constraints.Function;
import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.slang3.Scope;
import com.jacobalbano.slang3.functions.*;
import haxe.ds.Map;
import haxepunk.Entity;
import haxepunk.Tween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.utils.Ease;
import haxepunk.graphics.Image;
import openfl.Assets;

/**
	 * @author Jake Albano
	 */
class Actor extends XMLEntity
{
    public var actorName : String;
	public var graphicSource:String;
    
    private var director : Director;
    private var actionQueue : Array<Scope>;
    private var role : Scope;
    private var cursor : Int = 0;
    private var delayUntil : Float = 0;
    private var responses :  Map<String, Void->Void>;
    
    /**
		 * Actors can:
			 * respond to messages
			 * respond and dispatch action cues
			 * display thought bubbles
			 * have a graphic
		 */
    public function new()
    {
        super();
        responses = new Map<String, Void->Void>();
        actionQueue = [];
        role = new Scope(FPGame.globalSlang);
        
        role.setFunction(new NativeFunction("think", think, 2, Procedure, null, this));
        role.setFunction(new NativeFunction("delay", delay, 1, Procedure, null, this));
        role.setFunction(new NativeFunction("action", action, 1, Procedure, null, this));
        role.setFunction(new NativeFunction("await-cue", awaitCue, 2, Procedure, null, this));
        role.setFunction(new NativeFunction("give-cue", giveCue, 1, Procedure, null, this));
        role.setFunction(new NativeFunction("done", done, 0, Procedure, null, this));
        role.setFunction(new NativeFunction("message", sendMessage, 1, Procedure, null, this));
    }
    
    public function messageResponse(message : String, response : Void->Void) : Void
    {
        responses.set(message, response);
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
		if (graphicSource != null && graphicSource != "")
			graphic = new Image(graphicSource);
    }
    
    override public function update() : Void
    {
        super.update();
        
        findDirector();
        
        if (cursor < actionQueue.length)
        {
            if (Math.round(haxe.Timer.stamp() * 1000) <= delayUntil)
            {
                return;
            }
            
            actionQueue[cursor].execute();
        }
        else
        {
            finish();
        }
    }
    
    private function finish() : Void
    {
        if (director != null)
        {
            director.onActorFinished(this);
        }
    }
    
    /**
		 * Find the director entity if it hasn't been found yet
		 */
    private function findDirector() : Void
    {
        if (director != null)
        {
            return;
        }
        
        var all : Array<Director> = [];
        world.getClass(Director, all);
        
        for (item in all)
        {
            item.addActor(this);
            director = item;
            break;
        }
    }
    
    public function loadRole(name : String) : Void
    {
        FPGame.compile(Xml.parse(Assets.getText('scripts/${name}.xml')).firstElement().firstChild().nodeValue, role).execute();
    }
    
    /**
		 * Slang function!
		 * Display a thought bubble
		 * @param	seconds	How long to display the thought before fading out
		 * @param	thought	The thought to display (from lib/art/thoughts)
		 */
    private function think(seconds : Int, thought : String) : Void
    {
        if (world == null)
            return;
        
        world.add(new Thought(this, seconds, thought));
    }
    
    /**
		 * Slang function!
		 * Return if the named cue hasn't been given yet
		 * @param	name	The name of the cue
		 */
    private function awaitCue(name : String, scope : Scope) : Void
    {
        if (director.hasCue(name))
        {
            scope.execute();
        }
    }
    
    /**
		 * Slang function!
		 * Give a cue to other actors
		 * @param	name
		 */
    private function giveCue(name : String) : Void
    {
        if (director != null)
        {
            director.giveCue(name);
        }
    }
    
    /**
		 * Slang function!
		 * Suspend action execution for a given number of seconds
		 * @param	seconds	The number of seconds to delay
		 */
    private function delay(seconds : Float) : Void
    {
        delayUntil = Math.round(haxe.Timer.stamp() * 1000) + (seconds * 1000);
    }
    
    /**
		 * Slang function!
		 * Enqueue an action block
		 * @param	scope	The block to execute for this action
		 */
    private function action(scope : Scope) : Void
    {
        actionQueue.push(scope);
    }
    
    /**
		 * Slang function!
		 * Advance the action cursor
		 */
    private function done() : Void
    {
        cursor++;
    }
    
    private function sendMessage(message : String) : Void
    {
        var func = responses.get(message);
        if (func != null)
        {
            func();
        }
        else
        {
            trace("the message \"" + message + "\" isn't registered for", actorName);
        }
    }
}

