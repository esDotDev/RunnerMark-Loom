package  
{
	import cocos2d.CCAnimate;
	import cocos2d.CCAnimation;
	import cocos2d.CCArray;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrame;
	import cocos2d.CCSpriteFrameCache;
	
	public class Runner extends GameObject
	{	
		public function Runner() {	
			
			//Create animated sprite
			var frameCache:CCSpriteFrameCache = CCSpriteFrameCache.sharedSpriteFrameCache();
			var frameList = CCArray.array();
			var frameName:String, spriteFrame:CCSpriteFrame;
			for (var i = 0, l = 16; i < l; i++) {
				//Add frames "Runner.swf/0000" - "Runner.swf/0015"
				frameName = (i >= 10? "Runner.swf/00" : "Runner.swf/000") + i;
				spriteFrame = frameCache.spriteFrameByName(frameName);
				frameList.addObject(spriteFrame);
			}
			
			var runnerAnimation = CCAnimation.animationWithSpriteFrames(frameList, 1 / 24);
			runnerAnimation.setLoops( -1); //Loop indefinately
			sprite = CCSprite.create();
			sprite.runAction(CCAnimate.create(runnerAnimation)); //Play the animation we just assembled
			sprite.setAnchorPoint(new CCPoint(0, 0));
			
			//Cache size for faster lookup
			_width = spriteFrame.getRectInPixels().width;
			_height = spriteFrame.getRectInPixels().height;	
		}
	}
	
}