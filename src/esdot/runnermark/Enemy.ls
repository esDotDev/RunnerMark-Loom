package esdot.runnermark
{
	import cocos2d.CCAnimate;
	import cocos2d.CCAnimation;
	import cocos2d.CCArray;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrame;
	import cocos2d.CCSpriteFrameCache;
	
	import RunnerMark;
	
	public class Enemy extends GameObject
	{	
		protected var movieClip:AtlasAnimation;
		
		public var groundY:Number;
		
		protected var velY:int = 0;
		protected var gravity:Number = 1;
		protected var isJumping:Boolean = false;
		
		public function Enemy() {	
			
			//Cache frameLabels for quick lookup
			var frameLabels:Vector.<String> = [];

			for (var i = 0, l = 18; i < l; i++) {
				frameLabels.pushSingle((i >= 10? "Enemy.swf/00" : "Enemy.swf/000") + i);
			}
			
			movieClip = new AtlasAnimation("RunnerMark", frameLabels, 24);
			sprite = movieClip.sprite;
			
			//Cache size for faster lookup
			_width = movieClip.width;
			_height = movieClip.height;	
		}
		
		public function update(elapsed:Number):Void {
			
			movieClip.update(elapsed);
			
			velY -= gravity;
			sprite.y += velY; 
			if(sprite.y < groundY){
				sprite.y = groundY;
				isJumping = false;
				velY = 0;
			}
			
			if(!isJumping && velY == 0 && Math.random() < .02){
				velY = height * .35;
				isJumping = true;
			}
			
		}
		
	}
	
}