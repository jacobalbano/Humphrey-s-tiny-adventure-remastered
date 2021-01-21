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
    private var tweenIn : VarTween;
    private var tweenOut : VarTween;
    
    public function new()
    {
        super();
        graphic = Image.createCircle(1);
        
        tweenOut = new VarTween(OneShot);
		tweenOut.onComplete.bind(fadeIn);
		
        tweenIn = new VarTween(OneShot);
		tweenIn.onComplete.bind(fadeOut);
        
        fadeOut();
    }
    
    private function fadeOut() : Void
    {
        tweenOut.tween(graphic, "alpha", 0.9, 1 + Random.randInt(10) / 10.0);
        addTween(tweenOut, true);
    }
    
    private function fadeIn() : Void
    {
        tweenIn.tween(graphic, "alpha", 0.1, 1 + Random.randInt(10) / 10.0);
        addTween(tweenIn, true);
    }
}

