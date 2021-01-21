package com.jacobalbano.humphrey;


import com.jacobalbano.punkutils.XMLEntity;
import openfl.Assets;
import com.jacobalbano.slang3.Scope;

/**
	 * ...
	 * @author Jake Albano
	 */
class Script extends XMLEntity
{
    public var loadSource : String;
    public var updateSource : String;
    
    private var onLoad : Scope;
    private var onUpdate : Scope;
    
    public function new()
    {
        super();
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        if (loadSource != "")
        {
            try
            {
                var loadText : String = Xml.parse(Assets.getText('scripts/${loadSource}.xml')).firstElement().firstChild().nodeValue;
                if (loadText != "")
                    onLoad = FPGame.compile(loadText);
            }
            catch (err)
            {
                trace(err);
            }
        }
        
        if (updateSource != "")
        {
            try
            {
                var updateText : String = Xml.parse(Assets.getText('scripts/${updateSource}.xml')).firstElement().firstChild().nodeValue;
                if (updateText != "")
                    onUpdate = FPGame.compile(updateText);
            }
            catch (err)
            {
                trace(err);
            }
        }
    }
    
    override public function added() : Void
    {
        super.added();
        try
        {
			if (onLoad != null)
				onLoad.execute();
        }
        catch (err)
        {
            trace(err);
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        try
        {
			if (onUpdate != null)
				onUpdate.execute();
        }
        catch (err)
        {
            trace(err);
        }
    }
}

