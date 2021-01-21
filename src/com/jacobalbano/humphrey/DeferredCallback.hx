package com.jacobalbano.humphrey;

import haxe.Constraints.Function;
import haxepunk.Entity;

/**
	 * ...
	 * @author Jake Albano
	 */
class DeferredCallback extends Entity
{
    private var callback : Void->Bool;
    
    public function new(f : Void->Bool)
    {
        super();
        callback = f;
    }
    
    override public function update() : Void
    {
        if (callback())
        {
            world.remove(this);
        }
    }
}

