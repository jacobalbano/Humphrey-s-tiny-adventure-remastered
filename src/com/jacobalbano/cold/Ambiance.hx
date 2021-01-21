package com.jacobalbano.cold;

import com.jacobalbano.punkutils.XMLEntity;
import haxepunk.Sfx;
import haxepunk.Tween;
import haxepunk.tweens.sound.SfxFader;

/**
	 * ...
	 * @author Jake Albano
	 */
class Ambiance extends XMLEntity
{
    
    public var loop : Bool = false;
    public var source : String = null;
    public var tween : Float = 0;
    public var volume : Float = 0;
    private var sound : Sfx = null;
    private var fader : SfxFader = null;
    
    public function new()
    {
        super();
    }
    
    override public function added() : Void
    {
        super.added();
        
        sound = new Sfx("sounds/" + source, repeat);
        
        repeat();
    }
    
    private function repeat() : Void
    {
        sound.play(0);
        fader = new SfxFader(sound, TweenType.OneShot);
        fader.fadeTo(volume, tween);
        addTween(fader, true);
    }
    
    override public function removed() : Void
    {
        super.removed();
        
        fader = new SfxFader(sound, TweenType.OneShot);
        fader.onComplete.bind(sound.stop);
        fader.fadeTo(0, tween);
        
        world.addTween(fader, true);
    }
}

