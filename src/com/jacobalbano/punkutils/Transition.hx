package com.jacobalbano.punkutils;

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
        super(0, 0);//TODO , HXP.screen.capture());
        //TODO: graphic.scrollX = graphic.scrollY = 0;
    }
    
    override public function update() : Void
    {
        super.update();
        
		// TODO
        //var image : haxepunk.graphics.Image = try cast(graphic, haxepunk.graphics.Image) catch(e:Dynamic) null;
        //if ((image.alpha -= 0.075) <= 0)
        //{
            //HXP.world.remove(this);
        //}
    }
}

