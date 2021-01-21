package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Point;
import haxe.xml.Access;
import haxepunk.Sfx;
import haxepunk.graphics.Image;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.utils.Ease;

/**
	 * ...
	 * @author Jake Albano
	 */
class Subway extends XMLEntity
{
    public var flipped : Bool;
    
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
        //TODO 
        //for (item in entity.node.node.innerData)
        //{
            //var to = new Point(item.att.x, item.att.y);
            //var tween : MultiVarTween = new MultiVarTween();
            //tween.tween(this, { x : to.x, y : to.y }, 1.9, Ease.expoInOut);
            //addTween(tween, true);
            //break;
        //}
        
        var arrive : Sfx = new Sfx("sounds/subway.mp3");
        arrive.play(2, (flipped) ? 0.8 : -0.8);
    }
}

