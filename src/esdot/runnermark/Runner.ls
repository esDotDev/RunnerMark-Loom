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
		protected var velY:int = 0;
		protected var gravity:Number = 1;
		protected var isJumping:Boolean = false;
		
		public var enemyList:Vector.<Enemy>
		public var groundY:Number;
		
		
		public function Runner() {	
			
			//Create an AtlasMovieClip
			var frameLabels:Vector.<String> = [];
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
			
			velY -= gravity;
			sprite.y += velY; 
			if(sprite.y < groundY){
				sprite.y = groundY;
				isJumping = false;
				velY = 0;
			}
			
			if(!enemyList || isJumping){ return; }
			var enemy:Enemy;
			for(var i:int = 0, l:int = enemyList.length; i < l; i++){
				enemy = enemyList[i];
				if(enemy.sprite.x > this.sprite.x && enemy.sprite.x - this.sprite.x < this.width * 1.5){
					velY = 22;
					isJumping = true;
					break;
				}
			}
		}
		
		
	}
	
}