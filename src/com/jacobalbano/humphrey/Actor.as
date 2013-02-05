package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.Image;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.jacobalbano.slang.SlangFunction;
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import net.flashpunk.Entity;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * @author Jake Albano
	 */
	public class Actor extends XMLEntity 
	{
		public var actorName:String;
		
		private var director:Director;
		private var actionQueue:Array;
		private var role:Scope;
		private var cursor:int;
		private var delayUntil:Number;
		private var responses:Dictionary;
		
		/**
		 * Actors can:
			 * respond to messages
			 * respond and dispatch action cues
			 * display thought bubbles
			 * have a graphic
		 */
		public function Actor() 
		{
			responses = new Dictionary();
			actionQueue = [];
			role = new Scope(Game.instance.console.slang);
			
			role.addFunction(new SlangFunction("think", think).self(this).paramCount(2));
			role.addFunction(new SlangFunction("delay", delay).self(this).paramCount(1));
			role.addFunction(new SlangFunction("action", action).self(this).paramCount(1));
			role.addFunction(new SlangFunction("await-cue", awaitCue).self(this).paramCount(2));
			role.addFunction(new SlangFunction("give-cue", giveCue).self(this).paramCount(1));
			role.addFunction(new SlangFunction("done", done).self(this));
			role.addFunction(new SlangFunction("message", sendMessage).self(this).paramCount(1));
		}
		
		public function messageResponse(message:String, response:Function):void
		{
			responses[message] = response;
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			if (entity.@graphicSource)
			{
				var s:String = entity.@graphicSource;
				graphic = new Image(Library.getImage(s));
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			findDirector();
			
			if (cursor < actionQueue.length)
			{
				if (getTimer() <= delayUntil)
				{
					return;
				}
				
				actionQueue[cursor].execute();
			}
		}
		
		/**
		 * Find the director entity if it hasn't been found yet
		 */
		private function findDirector():void 
		{
			if (director)
			{
				return;
			}
			
			trace(actorName, "is looking for the director");
			
			var all:Array = [];
			world.getClass(Director, all);
			
			for each (var item:Director in all) 
			{
				item.addActor(this);
				director = item;
				trace(actorName, "has found for the director");
				break;
			}
		}
		
		public function loadRole(name:String):void
		{
			role.compile(Library.getXML("scripts." + name + ".xml").text()).execute();
		}
		
		/**
		 * Slang function!
		 * Display a thought bubble
		 * @param	seconds	How long to display the thought before fading out
		 * @param	thought	The thought to display (from lib/art/thoughts)
		 */
		private function think(seconds:int, thought:String):void
		{
			if (!world)
			{
				return;
			}
			
			world.add(new Thought(this, seconds, thought));
		}
		
		/**
		 * Slang function!
		 * Return if the named cue hasn't been given yet
		 * @param	name	The name of the cue
		 */
		private function awaitCue(name:String, scope:Scope):void
		{
			if (director.hasCue(name))
			{
				scope.execute();
			}
		}
		
		/**
		 * Slang function!
		 * Give a cue to other actors
		 * @param	name
		 */
		private function giveCue(name:String):void
		{
			if (director)
			{
				director.giveCue(name);
			}
		}
		
		/**
		 * Slang function!
		 * Suspend action execution for a given number of seconds
		 * @param	seconds	The number of seconds to delay
		 */
		private function delay(seconds:Number):void
		{
			delayUntil = getTimer() + (seconds * 1000);
		}
		
		/**
		 * Slang function!
		 * Enqueue an action block
		 * @param	scope	The block to execute for this action
		 */
		private function action(scope:Scope):void
		{
			actionQueue.push(scope);
		}
		
		/**
		 * Slang function!
		 * Advance the action cursor
		 */
		private function done():void
		{
			cursor++;
		}
		
		private function sendMessage(message:String):void
		{
			var func:Function = responses[message];
			if (func != null)
			{
				func();
			}
			else
			{
				trace("the message \"" + message + "\" isn't registered for", actorName);
			}
		}
		
	}

}