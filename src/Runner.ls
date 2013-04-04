package  
{
	import cocos2d.CCAnimate;
	import cocos2d.CCAnimation;
	import cocos2d.CCArray;
	import cocos2d.CCNode;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrame;
	import cocos2d.CCSpriteFrameCache;
	
	public class Runner 
	{	
		public var sprite:CCSprite;
		
		public var width:Number;
		public var height:Number;
		
		public function Runner(frameCache:CCSpriteFrameCache) 
		{	
			var frameList = CCArray.array();
			var frameName:String, spriteFrame:CCSpriteFrame;
			
			//Create animated sprite
			for (var i = 0, l = 16; i < l; i++) {
				//Add frames Runner.swf/0000 - Runner.swf/0015
				frameName = (i >= 10? "Runner.swf/00" : "Runner.swf/000") + i;
				spriteFrame = frameCache.spriteFrameByName(frameName);
				frameList.addObject(spriteFrame);
			}
			var runnerAnimation = CCAnimation.animationWithSpriteFrames(frameList, 1 / 24);
			runnerAnimation.setLoops( -1);
			sprite = CCSprite.create();
			sprite.runAction(CCAnimate.create(runnerAnimation));
			sprite.setAnchorPoint(new CCPoint(0, 0));
			sprite.x = RunnerMarkLoom.width * .2;
			
			//Extract width and height of this image for later
			width = spriteFrame.getRectInPixels().width;
			height = spriteFrame.getRectInPixels().height;	
		}
		
		public function get x():Number { return sprite.x; }
		public function get y():Number { return sprite.y; }
		
		public function enter(root:CCNode):void {
			root.addChild(sprite);
			
			
			
		}
		
	}
	
}