package esdot.runnermark 
{
	import cocos2d.CCAnimate;
	import cocos2d.CCAnimation;
	import cocos2d.CCArray;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrame;
	import cocos2d.CCSpriteFrameCache;
	import Loom.GameFramework.IAnimated;
	import UI.AtlasSprite;
	
	import RunnerMark;
	
	public class Runner extends GameObject 
	{	
		protected var movieClip:AtlasAnimation;
		
		public function Runner() {	
			
			//Create an AtlasMovieClip
			var frameLabels:Vector.<String> = new Vector.<String>();
			for (var i = 0, l = 16; i < l; i++) {
				frameLabels.pushSingle((i >= 10? "Runner.swf/00" : "Runner.swf/000") + i);
			}
			movieClip = new AtlasAnimation("RunnerMark", frameLabels, 24);
			sprite = movieClip.sprite;
			
			//Cache size for faster lookup
			_width = movieClip.width;
			_height = movieClip.height;	
		}
		
		public function update(elapsed:Number):Void {
			movieClip.update(elapsed);
		}
		
		
	}
	
}