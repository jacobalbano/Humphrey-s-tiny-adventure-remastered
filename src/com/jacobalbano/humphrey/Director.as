package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.jacobalbano.slang.SlangFunction;
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Director extends XMLEntity 
	{
		public var script:String;
		
		private var cues:Dictionary;
		private var actors:Array;
		private var scope:Scope;
		private var openRoles:Array;
		
		
		public function Director() 
		{
			cues = new Dictionary();
			actors = [];
			openRoles = [];
			
			scope = new Scope(Game.instance.console.slang);
			scope.addFunction(new SlangFunction("fill-role", fillRole).paramCount(2).self(this));
			scope.addFunction(new SlangFunction("has", hasCue).self(this).paramCount(1));
		}
		
		override public function added():void 
		{
			super.added();
			
			scope.compile(Library.getXML("scripts." + script + ".xml").text()).execute();
		}
		
		/**
		 * Instruct an actor to load a script for this role
		 * @param	actor		The actor's name
		 * @param	scriptName	The name of the script file
		 */
		public function fillRole(actor:String, scriptName:String):void
		{
			for each (var item:Actor in actors) 
			{
				if (item.name == actor)
				{
					item.loadRole(scriptName);
					return;
				}
			}
			
			openRoles.push([actor, scriptName])
		}
		
		/**
		 * Find whether a cue has been given
		 * @param	name	The name or identifier of the cue
		 * @return	whether a cue has been given
		 */
		public function hasCue(name:String):Boolean
		{
			return cues[name] != undefined;
		}
		
		/**
		 * Alert other actors of a cue
		 * @param	name	The name or identifier of the cue
		 */
		public function giveCue(name:String):void
		{
			cues[name] = true;
		}
		
		/**
		 * Adds an actor the active list
		 * @param	actor	The actor to add
		 */
		public function addActor(actor:Actor):void 
		{
			actors.push(actor);
			if (openRoles.length > 0)
			{
				for (var i:int = 0; i < openRoles.length; ++i) 
				{
					var item:Array = openRoles[i];
					
					if (item[0] == actor.actorName)
					{
						actor.loadRole(item[1]);
						openRoles.splice(i, 1);
						return;
					}
				}
			}
		}
	}

}