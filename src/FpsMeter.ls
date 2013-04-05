package  
{
	import Loom.GameFramework.ITicked;
	import Loom.GameFramework.TimeManager;
	
	/**
	 * ...
	 * @author esDot Studio
	 */
	public class FpsMeter implements ITicked
	{
		protected var time:TimeManager;
		
		public var elapsed:Number;
		public var fps:Number;
		public var frameFactor:Number;
		public var tickCount:Number;
		
		protected var lastT:int;
		
		public function FpsMeter(time:TimeManager) {
			this.time = time;
			time.addTickedObject(this);
			lastT = time.virtualTime;
			tickCount = 0;
		}
		
		protected function onTick():Void  {
			elapsed = time.virtualTime - lastT;
			fps = 1000 / elapsed;
			frameFactor = 60 / fps;
			lastT = time.virtualTime;
			tickCount++;
		}
		
	}
	
}