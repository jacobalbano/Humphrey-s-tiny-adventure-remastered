package com.jacobalbano.humphrey
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class PlayerTrigger extends XMLEntity
	{
		private var scope:Scope;
		
		public var script:String;
		
		public function PlayerTrigger()
		{
		}
		
		override public function load(entity:XML):void
		{
			super.load(entity);
			
			scope = new Scope(Game.instance.console.slang);
			
			try 
			{
				scope.compile(script);
			} 
			catch (err:Error) 
			{
				trace(err.getStackTrace());
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (collide("humphrey", x, y))
			{
				try 
				{
					scope.execute();
				} 
				catch (err:Error) 
				{
					trace(err.getStackTrace());
				}
			}
		}
	
	}

}