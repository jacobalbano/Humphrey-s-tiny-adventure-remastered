package com.jacobalbano.cold;

import haxepunk.graphics.Image;
import com.jacobalbano.punkutils.XMLEntity;

/**
	 * ...
	 * @author Jake Albano
     */
class Decal extends XMLEntity
{
    public var source : String;

    public var scrollX:Float = 0;
    public var scrollY:Float = 0;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        graphic = new Image('art/decals/${source}.png');

        graphic.scrollX = scrollX;
        graphic.scrollY = scrollY;
    }
}

