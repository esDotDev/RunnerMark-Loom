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
		
		public var totalTime:Number = 0;
		public var tickCount:Number = 0;
		public var elapsed:Number;
		public var fps:Number;
		public var frameFactor:Number;
		
		
		protected var lastT:int;
		
		public function FpsMeter(time:TimeManager) {
			this.time = time;
			time.addTickedObject(this);
			lastT = time.platformTime;
		}
		
		protected function onTick():Void  {
			elapsed = time.platformTime - lastT;
			if (elapsed > 100) { elapsed = 100; }
			if (elapsed == 0) { return; }
			totalTime += elapsed;
			lastT = time.platformTime;
			fps = 1000 / elapsed;
			frameFactor = 60 / fps;
			tickCount++;
		}
		
	}
	
}