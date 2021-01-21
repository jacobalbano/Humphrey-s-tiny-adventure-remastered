package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Point;
import haxepunk.graphics.Spritemap;
import haxepunk.Sfx;
import haxepunk.tweens.misc.MultiVarTween;
import haxepunk.tweens.misc.VarTween;
import haxepunk.tweens.motion.QuadPath;
import haxepunk.tweens.sound.SfxFader;
import haxepunk.utils.Ease;

/**
	 * ...
	 * @author Jake Albano
	 */
class Spinky extends XMLEntity
{
    public var isSad : Bool;
    
    private static var FACE_LEFT : Bool = false;
    private static var FACE_RIGHT : Bool = true;
    
    private var spritemap : Spritemap;
    private var actor : Actor;
    private var facing : Bool;
    
    public function new()
    {
        super();
        spritemap = new Spritemap("art/characters/spinky.png", 100, 100);
        spritemap.add("happy", [0]);
        spritemap.add("sad", [1]);
        spritemap.add("sad-bag", [2]);
        spritemap.centerOrigin();
        spritemap.originY = spritemap.height;
        graphic = spritemap;
        setHitboxTo(graphic);
        centerOrigin();
        originY = spritemap.height;
        
        actor = new Actor();
        actor.actorName = "spinky";
        actor.messageResponse("hopForward", hopForward);
        actor.messageResponse("hopInPlace", hopInPlace);
        actor.messageResponse("turn", turn);
        actor.messageResponse("getHappy", getHappy);
        actor.messageResponse("getSad", getSad);
        actor.messageResponse("getBag", getBag);
        actor.messageResponse("fade", fade);
        actor.messageResponse("remove", remove);
        actor.messageResponse("music", playMusic);
        
        facing = FACE_LEFT;
    }
    
    override public function added() : Void
    {
        super.added();
        world.add(actor);
    }
    
    override public function removed() : Void
    {
        super.removed();
        world.remove(actor);
    }
    
    override public function update() : Void
    {
        super.update();
        actor.x = x;
        actor.y = y;
    }
    
    //{ region message responses
    
    private function fade() : Void
    {
        var tween : VarTween = new VarTween(OneShot);
        tween.tween(graphic, "alpha", 0, 0.5, Ease.quadIn);
        addTween(tween, true);
    }
    
    private function getHappy() : Void
    {
        spritemap.play("happy");
        isSad = false;
    }
    
    private function getSad() : Void
    {
        spritemap.play("sad");
        isSad = true;
    }
    
    private function getBag() : Void
    {
        spritemap.play("sad-bag");
    }
    
    private function turn() : Void
    {
        facing = !facing;
        spritemap.flipped = facing;
    }
    
    private function hopForward() : Void
    {
        hop(false);
    }
    
    private function hopInPlace() : Void
    {
        hop(true);
    }
    
    private function remove() : Void
    {
        world.remove(this);
    }
    
    private function playMusic() : Void
    {
        var music : Sfx = new Sfx("sounds/music/ending.mp3");
        music.play();
    }
    //} endregion
    
    private function hop(inPlace : Bool) : Void
    {
        var self : Spinky = this;
        var grow : Void->Void = function() : Void
        {
            var tween : VarTween = new VarTween(OneShot);
            tween.tween(graphic, "scaleY", 1, 0.1);
            addTween(tween, true);
        }
		
        var squish : Void->Void = function() : Void
        {
            var tween : VarTween = new VarTween(OneShot);
			tween.onComplete.bind(grow);
            tween.tween(graphic, "scaleY", 0.7, 0.05);
            addTween(tween, true);
            
            var sound : Sfx = new Sfx("sounds/hop.mp3");
            sound.play();
        }
		
        var toward : Int = (facing == FACE_LEFT) ? 1 : -1;
        var speed : Int = (isSad) ? 20 : 50;
        
        var motion : QuadPath = new QuadPath(OneShot);
		motion.onComplete.bind(squish);
        
        if (inPlace)
        {
            motion.addPoint(x, y);
            motion.addPoint(x, y - speed);
            motion.addPoint(x, y);
            motion.setMotion(0.25);
            motion.object = this;
        }
        else
        {
            motion.addPoint(x, y);
            motion.addPoint(x - (speed * toward), y - speed);
            motion.addPoint(x - ((speed + speed / 2) * toward), y);
            motion.setMotion(0.25);
            motion.object = this;
        }
        
        addTween(motion, true);
    }
}

