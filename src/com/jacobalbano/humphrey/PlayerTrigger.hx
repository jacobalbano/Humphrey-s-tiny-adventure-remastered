package com.jacobalbano.humphrey;


import com.jacobalbano.punkutils.XMLEntity;
import com.jacobalbano.slang3.Scope;

/**
	 * ...
	 * @author Jake Albano
	 */
class PlayerTrigger extends XMLEntity
{
    private var scope : Scope;
    
    public var script : String;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        try
        {
            scope = FPGame.compile(script);
        }
        catch (err)
        {
            trace(err);
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        if (collide("humphrey", x, y) != null)
        {
            try
            {
                scope.execute();
            }
            catch (err)
            {
                trace(err);
            }
        }
    }
}

