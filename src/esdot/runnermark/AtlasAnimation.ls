package esdot.runnermark 
{
	import cocos2d.CCPoint;
	import UI.AtlasSprite;
	
	public class AtlasAnimation
	{
		public var sprite:AtlasSprite;
	
		protected var atlasId:String;
		protected var numFrames:Number;
		protected var frames:Vector.<String> = [];
		protected var frameMs:Number;
		protected var frameElapsed:Number;
		
		protected var _fps:Number;
		protected var _currentFrame:Number = 0;
		protected var _isPlaying:Boolean;
		protected var _width:Number;
		protected var _height:Number;
		
		public function AtlasAnimation(atlasId:String, frames:Vector.<String>, fps:Number = 24) {
			sprite = new AtlasSprite();
			sprite.setAnchorPoint(new CCPoint(0, 0));
			
			this.atlasId = sprite.atlasID = atlasId;
			
			this.frames = frames;
			numFrames = frames.length;
			
			this.fps = fps;
			
			_isPlaying = true;
			
			renderFrame();
			_width = sprite.displayFrame().getRectInPixels().width;
			_height = sprite.displayFrame().getRectInPixels().height;
			
		}
		
		public function update(elapsed:Number) {
			if (!isPlaying) { return; }
			frameElapsed += elapsed;
			while (frameElapsed > frameMs) {
				_currentFrame++;
				frameElapsed -= frameMs;
			}
			if (_currentFrame > frames.length - 1) {
				_currentFrame = 0;
			}
			renderFrame();
		}
		
		protected function renderFrame() {
			if (_currentFrame < 0) { _currentFrame = numFrames - 1; }//Loop backwards
			if (_currentFrame > numFrames - 1) { _currentFrame = 0; }//Loop forward
			sprite.texture = frames[_currentFrame];
		}
		
		public function get currentFrame():Number { return _currentFrame; }
		
		public function get isPlaying():Boolean { return _isPlaying; }
		
		public function get width():Number { return _width; }
		
		public function get height():Number { return _height; }
		
		public function get fps():Number { return _fps; }
		public function set fps(value:Number):void {
			_fps = value;
			frameMs = 1000 / _fps;
			frameElapsed = 0;
		}
		
		public function play():void {
			_isPlaying = true;
		}
		
		public function gotoAndPlay(frame:Number):void {
			_currentFrame = frame - 1;
		}
		
		public function stop():void {
			_isPlaying = false;
		}
		
		public function gotoAndStop(frame:Number):void {
			_currentFrame = frame - 1;
			renderFrame();
			isPlaying = false;
		}
		
		public function nextFrame():void {
			_currentFrame++;
			renderFrame();
		}
		
		public function prevFrame():void {
			_currentFrame--;
			renderFrame();
		}

		
		
	}
	
}