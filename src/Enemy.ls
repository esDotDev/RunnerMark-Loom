package  
{
	import cocos2d.CCAnimate;
	import cocos2d.CCAnimation;
	import cocos2d.CCArray;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrame;
	import cocos2d.CCSpriteFrameCache;
	
	public class Enemy extends GameObject
	{	
		protected static var s_width:int;
		protected static var s_height:int;
		
		protected static var animation:CCAnimation;
		
		public var groundY:Number;
		
		protected var velY:int = 0;
		protected var gravity:Number = 1;
		protected var isJumping:Boolean = false;
		
		public function Enemy() {	
			//Create the animation once and share for all Enemy instances
			if (!animation) {
				var frameCache = CCSpriteFrameCache.sharedSpriteFrameCache();
				var frameList = CCArray.array();
				var frameName:String, spriteFrame:CCSpriteFrame;
				
				//Create animated sprite
				for (var i = 0, l = 18; i < l; i++) {
					frameName = (i >= 10? "Enemy.swf/00" : "Enemy.swf/000") + i;
					spriteFrame = frameCache.spriteFrameByName(frameName);
					frameList.addObject(spriteFrame);
				}
				//Cache Animation
				animation = CCAnimation.animationWithSpriteFrames(frameList, 1 / 24);
				animation.setLoops( -1);
				
				//Cache size
				s_width = spriteFrame.getRectInPixels().width;
				s_height = spriteFrame.getRectInPixels().height;
			}
			
			_width = s_width;
			_height = s_height;	
			
			sprite = CCSprite.create();
			sprite.runAction(CCAnimate.create(animation));
			sprite.setAnchorPoint(new CCPoint(0, 0));
		}
		
		public function update():void {
			velY -= gravity;
			sprite.y += velY; 
			if(sprite.y < groundY){
				sprite.y = groundY;
				isJumping = false;
				velY = 0;
			}
			
			if(!isJumping && velY == 0 && Math.random() < .02){
				velY = height * .25;
				isJumping = true;
			}
		}
		
	}
	
}