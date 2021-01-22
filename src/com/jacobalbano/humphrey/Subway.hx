package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Point;
import haxepunk.Sfx;
import haxepunk.graphics.Image;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.utils.Ease;
import haxe.xml.Access;

/**
	 * ...
	 * @author Jake Albano
	 */
class Subway extends XMLEntity
{
    public var flipped : Bool = false;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        var image = new Image("art/decals/train.png");
        image.flipped = flipped;
        graphic = image;

        for (item in entity.elementsNamed("node"))
        {
            var to = new Point(Std.parseFloat(item.get("x")), Std.parseFloat(item.get("y")));
            var tween : MultiVarTween = new MultiVarTween();
            tween.tween(this, { x : to.x, y : to.y }, 1.9, Ease.expoInOut);
            addTween(tween, true);
            break;
        }
        
    }

    override public function added():Void
    {
        var arrive : Sfx = new Sfx("sounds/subway.mp3");
        arrive.play(2, (flipped) ? 0.8 : -0.8);
    }
}

