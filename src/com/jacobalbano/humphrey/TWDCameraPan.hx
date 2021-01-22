package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.CameraPan;

/**
 * ...
 * @author Jake Albano
 */
class TWDCameraPan extends CameraPan
{
    private var humphrey : Humphrey;
    
    public function new()
    {
        super();
    }

    override function load(entity:Xml) {
        super.load(entity);
        {
            var str = entity.get("buffer");
            if (str != null)
                buffer = Std.parseInt(str);
        }
        {
            var str = entity.get("scrollSpeed");
            if (str != null)
                scrollSpeed = Std.parseInt(str);
        }
    }
    
    override public function added() : Void
    {
        super.added();
        
        locateHumphrey();
    }
    
    override public function update() : Void
    {
        locateHumphrey();
        
        if (humphrey == null)
        {
            return;
        }
        
        super.update();
    }
    
    private function locateHumphrey() : Void
    {
        var all : Array<Humphrey> = [];
        world.getClass(Humphrey, all);
        
        for (item in all)
        {
            humphrey = item;
            break;
        }
    }
    
    override private function getTestX() : Float
    {
        return humphrey.x - world.camera.x;
    }
    
    override private function getTestY() : Float
    {
        return humphrey.y - world.camera.y;
    }
}

