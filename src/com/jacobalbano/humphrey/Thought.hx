package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.Tween;
import haxepunk.graphics.Image;
import haxepunk.utils.Ease;
import haxepunk.tweens.misc.VarTween;

/**
	 * ...
	 * @author Jake Albano
	 */
class Thought extends XMLEntity
{
    private var actor : Actor;
    private var seconds : Int;
    private var ticks : Int;
    
    public function new(actor : Actor, seconds : Int, thought : String)
    {
        super();
        this.seconds = seconds * 60;
        this.actor = actor;
        
        var image = new Image('art/thoughts/${thought}.png');
        image.alpha = 0;
        image.centerOO();
        graphic = image;
        
        var tween = new VarTween(OneShot);
        tween.tween(graphic, "alpha", 1, 0.5);
        addTween(tween, true);
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (actor != null)
        {
            x = actor.x;
            y = actor.y;
        }
        
        if (++ticks > seconds)
        {
            var tween = new VarTween(OneShot);
			tween.onComplete.bind(remove);
            tween.tween(graphic, "alpha", 0, 0.5);
            addTween(tween, true);
        }
    }
    
    private function remove() : Void
    {
        actor = null;
        world.remove(this);
    }
}

