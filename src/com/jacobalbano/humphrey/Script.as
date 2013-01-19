package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Script extends XMLEntity 
	{
		public var loadSource:String;
		public var updateSource:String;
		
		private var onLoad:Scope;
		private var onUpdate:Scope;
		
		public function Script() 
		{
			onLoad = new Scope(Game.instance.console.slang);
			onUpdate = new Scope(Game.instance.console.slang);
		}
		
		override public function load(entity:XML):void 
		{
			super.load(entity);
			
			if (loadSource != "")
			{
				try
				{
					var loadText:String = Library.getXML("scripts." + loadSource + ".xml").text();
					
					if (loadText != "")
					{
						onLoad.compile(loadText);
					}
				} 
				catch (err:Error) 
				{
					trace(err.message);
				}
			}
			
			if (updateSource != "")
			{
				try
				{
					var updateText:String = Library.getXML("scripts." + updateSource + ".xml").text();
					
					if (updateSource != "")
					{
						onUpdate.compile(updateText);
					}
				} 
				catch (err:Error) 
				{
					trace(err.message);
				}
			}
		}
		
		override public function added():void 
		{
			super.added();
			
			if (!onLoad.isCompiled)
			{
				return;
			}
			
			try
			{
				onLoad.execute();
			} 
			catch (err:Error) 
			{
				trace(err.getStackTrace());
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!onUpdate.isCompiled)
			{
				return;
			}
			
			try 
			{
				onUpdate.execute();
			} 
			catch (err:Error) 
			{
				//trace(err.getStackTrace());
			}
		}
		
	}

}