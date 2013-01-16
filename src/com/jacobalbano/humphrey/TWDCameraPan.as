package com.jacobalbano.humphrey 
{
	import com.jacobalbano.punkutils.CameraPan;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class TWDCameraPan extends CameraPan 
	{
		private var humphrey:Humphrey;
		
		public function TWDCameraPan() 
		{
			super();
		}
		
		override public function added():void 
		{
			super.added();
			
			locateHumphrey();
		}
		
		override public function update():void 
		{
			locateHumphrey();
			
			if (humphrey == null)
			{
				return;
			}
			
			super.update();
		}
		
		private function locateHumphrey():void 
		{
			var all:Array = [];
			world.getClass(Humphrey, all)
			
			for each (var item:Humphrey in all) 
			{
				humphrey = item;
				break;
			}
		}
		
		override protected function getTestX():Number 
		{
			return humphrey.x - world.camera.x;
		}
		
		override protected function getTestY():Number 
		{
			return humphrey.y - world.camera.y;
		}
		
	}

}