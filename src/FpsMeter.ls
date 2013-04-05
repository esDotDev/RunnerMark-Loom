package  
{
	import Loom.GameFramework.ITicked;
	import Loom.GameFramework.TimeManager;

	public class FpsMeter implements ITicked
	{
		public var totalTime:Number = 0;
		public var tickCount:Number = 0;
		public var elapsed:Number;
		public var fps:Number = 20;
		public var frameFactor:Number;
		
		protected var time:TimeManager;
		protected var frameCount:Number = 0;
		protected var frameTime:Number;
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
			frameFactor = 60 / fps;
			tickCount++;
			
			//Calculate average Fps every 1000ms
			frameCount++;
			frameTime += elapsed;
			if (frameTime > 1000) {
				fps = (1000 / frameTime) * frameCount;
				frameCount = frameTime = 0;
			}
			
		}
		
	}
	
}