package com.jacobalbano.punkutils;

import haxepunk.tweens.misc.VarTween;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Image;

/**
	 * Transition entity to fade between worlds
	 * @author Jacob Albano
	 */
class Transition extends Entity
{
    public function new()
    {
        //TODO: super(0, 0, HXP.screen.capture());
        super(0, 0, Image.createRect(HXP.width, HXP.height, 0x0, 1));
        graphic.scrollX = graphic.scrollY = 0;

        var tween = new VarTween(OneShot);
        tween.tween(graphic, "alpha", 0, 0.65);
        tween.onComplete.bind(() -> world.remove(this));
        addTween(tween, true);
        layer = -9001;
    }
}

