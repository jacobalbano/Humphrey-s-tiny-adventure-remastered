package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.graphics.emitter.Emitter;
import haxepunk.HXP;

/**
	 * @author Jake Albano
	 */
class ParticleEmitter extends XMLEntity
{
    private var lastTime : Float = 0;
    public var particleType : String = null;
    public var vary : Float = 0;
    public var max : Int = 0;
    public var emitter : Emitter = null;
    public var angle : Int = 0;
    public var distance : Float = 0;
    public var duration : Float = 0;
    public var angleRange : Float = 0;
    public var distanceRange : Float = 0;
    public var durationRange : Float = 0;
    public var fadeOut : Bool = false;
    
    public function new()
    {
        super();
        lastTime = 0;
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);

        emitter = new Emitter('art/particles/${particleType}.png');
        graphic = emitter;
        
        emitter.relative = false;
        emitter.newType(particleType);
        emitter.setMotion(particleType, -angle, distance, duration, angleRange, distanceRange, durationRange);
        emitter.setAlpha(particleType, 1, (fadeOut) ? 0 : 1);
        for (x in 0...1000)
        {
            update();
            emitter.update();
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        emitter.emit(particleType, x, y);
    }
}

