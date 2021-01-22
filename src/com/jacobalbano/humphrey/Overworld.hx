package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.OgmoWorld;
import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.slang3.Scope;
import com.jacobalbano.slang3.functions.*;
import haxepunk.World;
import haxepunk.graphics.Image;
import haxepunk.input.Input;
import haxepunk.input.Key;

/**
	 * ...
	 * @author Jake Albano
	 */
class Overworld extends XMLEntity
{
    private var image : Image;
    private static inline var ROTATE_SPEED : Float = 0.5;
    private var hasBalloon : Bool = false;
    
    public function new()
    {
        super();
        graphic = image = new Image("art/backgrounds/overworld.png");
        image.smooth = true;
        image.centerOrigin();
        
        centerOrigin();
        
        Input.define("up", [Key.W, Key.UP]);
        Input.define("down", [Key.S, Key.DOWN]);
        Input.define("right", [Key.D, Key.RIGHT]);
        Input.define("left", [Key.A, Key.LEFT]);
        
        var scope = new Scope(FPGame.globalSlang);
        scope.setFunction(new NativeFunction("hasBalloon?", findBalloon, 1, Function, null, this));
        FPGame.compile('hasBalloon? hasItem? "balloon"', scope).execute();
    }
    
    private function findBalloon(b : Bool) : Void
    {
        hasBalloon = b;
    }
    
    public static function rotateToZone(world : World, name : String) : Void
    {
        var find : Void->Bool = function() : Bool
        {
            var all : Array<Overworld> = [];
            world.getClass(Overworld, all);
            
            for (item in all)
            {
                item.setZone(name);
                return true;
            }
            
            return false;
        }
        
        
        if (!find())
        {
            world.add(new DeferredCallback(find));
        }
    }
    
    private function setZone(name : String) : Void
    {
        switch (name)
        {
            case "woods":
                image.angle = 0;
            case "desert":
                image.angle = 90;
            case "snow":
                image.angle = 180;
            case "city":
                image.angle = 270;
            default:
                return;
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        var moveOnX : Bool = false;
        
        if (Input.check("left"))
        {
            image.angle -= ROTATE_SPEED;
            moveOnX = true;
        }
        
        if (Input.check("right"))
        {
            image.angle += ROTATE_SPEED;
            moveOnX = true;
        }
        
        if (moveOnX)
        {
            return;
        }
        
        if (Input.check("up") || Input.check("down"))
        {
            try
            {
                FPGame.compile('world "${getZone()}"').execute();
            }
            catch (err)
            {
                trace(err);
            }
        }
    }
    
    private function getZone() : String
    {
        var position : Int = Std.int(image.angle % 360);
        position = (position < 0) ? position + 360 : position;
        
        var between : Int->Int->Bool = function(i1 : Int, i2 : Int) : Bool
        {
            return position >= i1 && position <= i2;
        }
        
        if (between(315, 360) || between(0, 35))
        {
            return (hasBalloon) ? "woods-river" : "woods-gate";
        }
        
        if (between(215, 315))
        {
            return "city-hub";
        }
        
        if (between(35, 125))
        {
            return "desert-hub";
        }
        
        return "snow-hub";
    }
}

