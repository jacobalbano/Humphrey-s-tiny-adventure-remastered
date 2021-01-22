package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.HXP;
import haxepunk.graphics.Image;
import haxepunk.tweens.misc.VarTween;
import haxepunk.math.Random;

/**
	 * ...
	 * @author Jake Albano
	 */
class Star extends XMLEntity
{
    public function new()
    {
        super();
        var img = Image.createCircle(1);
        img.scale = 0.5 + Random.randInt(10) / 10.0;
        graphic = img;
        
        
        fadeOut();
    }
    
    private function fadeOut() : Void
    {
        var tweenOut = new VarTween(OneShot);
		tweenOut.onComplete.bind(fadeIn);
        tweenOut.tween(graphic, "alpha", 0.9, 1 + Random.randInt(10) / 10.0);
        addTween(tweenOut, true);
    }
    
    private function fadeIn() : Void
    {
        var tweenIn = new VarTween(OneShot);
		tweenIn.onComplete.bind(fadeOut);
        tweenIn.tween(graphic, "alpha", 0.1, 1 + Random.randInt(10) / 10.0);
        addTween(tweenIn, true);
    }
}

