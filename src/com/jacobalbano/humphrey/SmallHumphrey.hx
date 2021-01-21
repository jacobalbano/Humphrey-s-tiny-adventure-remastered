package com.jacobalbano.humphrey;

import com.jacobalbano.slang3.Scope;
import com.jacobalbano.slang3.functions.NativeFunction;
import haxepunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.graphics.Spritemap;
import haxepunk.input.Input;

/**
	 * ...
	 * @author Jake Albano
	 */
class SmallHumphrey extends XMLEntity
{
    private var humphrey : Humphrey;
    private var spritemap : Spritemap;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        var scope = new Scope(FPGame.globalSlang);
        scope.setFunction(new NativeFunction("hasBalloon?", findBalloon, 1, Procedure, null, this));
        FPGame.compile("hasBalloon? hasItem? \"balloon\"", scope);
        scope.execute();
    }
    
    private function findBalloon(hasBalloon : Bool) : Void
    {
        if (hasBalloon)
        {
            var balloon = new Image("art/characters/balloon.png");
            balloon.centerOrigin();
            balloon.originY = balloon.height;
            y -= balloon.height;
            graphic = balloon;
        }
        else
        {
            humphrey = new Humphrey();
            spritemap = try cast(humphrey.graphic, Spritemap) catch(e:Dynamic) null;
            
            spritemap.scale = 0.1;
            spritemap.smooth = true;
            graphic = spritemap;
        }
    }
    
    override public function update() : Void
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
    
    override public function added() : Void
    {
        super.added();
        
        if (humphrey != null)
        {
            world.add(humphrey);
        }
    }
    
    override public function removed() : Void
    {
        super.removed();
        
        if (humphrey != null)
        {
            world.remove(humphrey);
        }
    }
}

