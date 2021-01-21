package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.slang3.Scope;
import com.jacobalbano.slang3.functions.NativeFunction;
import flash.geom.Point;
import haxepunk.Tween;
import haxepunk.graphics.Image;
import haxepunk.tweens.misc.VarTween;
import haxepunk.utils.Ease;
import haxepunk.input.Input;
import haxepunk.input.Mouse;

/**
	 * ...
	 * @author Jake Albano
	 */
class Pickup extends XMLEntity
{
    private var contains : Bool = false;
    private var scope : Scope;
    private var humphrey : Humphrey;
    private var actor : Actor;
    
    public var typeName : String;
    
    public function new()
    {
        super();
        actor = new Actor();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        var image = new Image('art/pickups/${typeName}.png');
        
        setHitbox(image.width, image.height);
        centerOrigin();
        image.centerOrigin();
        graphic = image;
        
		scope = FPGame.compile('collectItem "${typeName}"');
    }
    
    override public function added() : Void
    {
        super.added();
        
        world.add(actor);
        
        locateHumphrey();
        
        try
        {
            var removeMe = new Scope(FPGame.globalSlang);
            removeMe.setFunction(new NativeFunction("removeMe", collected, 0, Procedure, null, this));
            
            FPGame.compile('if hasItem? "${typeName}" { collectItem "${typeName}" removeMe }', removeMe)
				.execute();
        }
        catch (err)
        {
            trace(err);
        }
    }
    
    override public function removed() : Void
    {
        super.removed();
        
        world.remove(actor);
        
        if (collidePoint(x, y, world.mouseX, world.mouseY))
        {
            flash.ui.Mouse.cursor = flash.ui.MouseCursor.ARROW;
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        var lastContain : Bool = contains;
        contains = collidePoint(x, y, world.mouseX, world.mouseY);
        
        if (contains)
        {
            if (Mouse.mouseReleased)
            {
                onClick();
            }
            
            flash.ui.Mouse.cursor = flash.ui.MouseCursor.BUTTON;
        }
        
        if (lastContain != contains)
        {
            if (!contains)
            {
                flash.ui.Mouse.cursor = flash.ui.MouseCursor.ARROW;
            }
        }
    }
    
    private function onClick() : Void
    {
        locateHumphrey();
        
        if (humphrey == null)
        {
            return;
        }
        
        var here = new Point(this.x, this.y);
        var there = new Point(humphrey.x, humphrey.y);
        var distance = Point.distance(here, there);
        
        if (distance > humphrey.width * 4)
        {
            return;
        }
        
        try
        {
            var all : Array<Director> = [];
            world.getClass(Director, all);
            
            for (item in all)
            {
                item.giveCue(typeName);
                break;
            }
            
            scope.execute();
            
            var tween = new VarTween(OneShot);
			tween.onComplete.bind(collected);
            tween.tween(graphic, "alpha", 0, 0.5, Ease.expoOut);
            addTween(tween, true);
        }
        catch (err)
        {
            trace(err);
        }
    }
    
    private function collected() : Void
    {
        if (world != null)
        {
            world.remove(this);
        }
    }
    
    private function locateHumphrey() : Void
    {
        if (humphrey != null)
        {
            return;
        }
        
        var all : Array<Humphrey> = [];
        world.getClass(Humphrey, all);
        
        if (all.length == 0)
        {
            return;
        }
        
        humphrey = all[0];
    }
}

