package com.jacobalbano.humphrey;

import com.jacobalbano.punkutils.OgmoWorld;
import com.jacobalbano.punkutils.XMLEntity;
import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
import haxepunk.Sfx;
import openfl.Assets;
import haxepunk.input.Input;
import haxepunk.input.Key;
import haxepunk.math.Random;

/**
	 * ...
	 * @author Jake Albano
	 */
class Humphrey extends XMLEntity
{
    private var velocity : Point;
    private var animation : Spritemap;
    private static var ZERO : Point = new Point();
    
    public var walkSpeed : Float = 0;
    public var hasBackpack : Bool = false;
    public var flipped : Bool = false;
	public var scale:Float = 0;
    
    private var lastAnimIndex : Int = 0;
    private var stepSounds : Array<Sfx>;
    
    private var actor : Actor;
    private var canMove : Bool = false;
    
    public function new()
    {
        super();
        canMove = true;
        
        //	animation
        animation = new Spritemap("art/characters/humphrey.png", 150, 200);
        graphic = animation;
        animation.centerOrigin();
        
        animation.add("stand", [0]);
        animation.add("stand-backpack", [8]);
        
        animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 10, true);
        animation.add("walk-backpack", [8, 9, 10, 11, 12, 13, 14, 15], 10, true);
        animation.add("sit", [16]);
        
        //	collision
        type = "humphrey";
        setHitbox(50, 50, Std.int(150 / 4), -50);
        
        //	input
        Input.define("left", [Key.A, Key.LEFT]);
        Input.define("right", [Key.D, Key.RIGHT]);
        Input.define("up", [Key.W, Key.UP]);
        Input.define("down", [Key.S, Key.DOWN]);
        
        //	sounds
        stepSounds = [];
        velocity = new Point();
        
        actor = new Actor();
        actor.actorName = "humphrey";
        actor.messageResponse("sit", sit);
        actor.messageResponse("stand", stand);
        actor.messageResponse("stop moving", stopMovement);
    }
    
    override public function load(entity : Xml) : Void
    {
        super.load(entity);
        
        if (scale != 0)
        {
            animation.scale = scale;
            walkSpeed *= scale;
        }
    }
    
    override public function added() : Void
    {
        super.added();
        
        world.add(actor);
        
        animation.flipped = flipped;
        
        var all : Array<FootstepSound> = [];
        world.getClass(FootstepSound, all);
        for (item in all)
        {
            loadFootsteps(item.material);
            return;
        }
        
        trace("couldn't find footsteps");
    }
    
    override public function removed() : Void
    {
        super.removed();
        
        world.remove(actor);
    }
    
    private function loadFootsteps(material : String) : Void
    {
        var search : String = "";
        var search = switch (material)
        {
            case "snow":
                search = "footsteps-snow";
            case "hard":
                search = "footsteps-hard";
            case "sand":
                search = "footsteps-sand";
            case "dirt":
                search = "footsteps-dirt";
            default:
				return;
        }
        
        for (name in Assets.list())
        {
            if (name.indexOf(search) >= 0)
                stepSounds.push(new Sfx(name));
        }
    }
    
    override public function update() : Void
    {
        super.update();
        
        actor.x = x;
        actor.y = y;
        
        checkMovement();
        
        updateAnimation();
        
        playFootstepSound();
    }
    
    private function checkMovement() : Void
    {
        if (!canMove)
        {
            return;
        }
        
        velocity.x = velocity.y = 0;
        
        if (Input.check("left"))
        {
            velocity.x -= walkSpeed;
        }
        
        if (Input.check("right"))
        {
            velocity.x += walkSpeed;
        }
        
        if (Input.check("up"))
        {
            velocity.y -= walkSpeed;
        }
        
        if (Input.check("down"))
        {
            velocity.y += walkSpeed;
        }
        
        velocity.normalize(walkSpeed);
        moveBy(velocity.x, velocity.y, "boundary");
    }
    
    private function updateAnimation() : Void
    {
        if (!canMove)
        {
            return;
        }
        
        if (velocity.equals(ZERO))
        {
            if (hasBackpack)
            {
                animation.play("stand-backpack");
            }
            else
            {
                animation.play("stand");
            }
        }
        else
        {
            if (velocity.x > 0)
            {
                animation.flipped = false;
            }
            else if (velocity.x < 0)
            {
                animation.flipped = true;
            }
            
            if (hasBackpack)
            {
                animation.play("walk-backpack");
            }
            else
            {
                animation.play("walk");
            }
        }
    }
    
    override public function moveCollideX(e : Entity) : Bool
    {
        velocity.x = 0;
        return super.moveCollideX(e);
    }
    
    override public function moveCollideY(e : Entity) : Bool
    {
        velocity.y = 0;
        return super.moveCollideY(e);
    }
    
    public function notifyOfItem(name : String) : Void
    {
        switch (name)
        {
            case "backpack":
                hasBackpack = true;
            default:
        }
    }
    
    private function playFootstepSound() : Void
    {
        if (stepSounds.length == 0)
        {
            return;
        }
        
        //	only play the sound when Humphrey first puts his foot down
        if (animation.index != lastAnimIndex && animation.index % 4 == 0)
        {
            stepSounds[Random.randInt(stepSounds.length)].play(0.25);
        }
        
        lastAnimIndex = animation.index;
    }
    
    //{ region message responses
    
    private function sit() : Void
    {
        canMove = false;
        animation.play("sit");
    }
    
    private function stand() : Void
    {
        canMove = true;
    }
    
    private function stopMovement() : Void
    {
        canMove = false;
    }
}

