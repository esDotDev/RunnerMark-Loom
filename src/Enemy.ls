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
	
	public class Enemy 
	{	
		protected static var animation:CCAnimation;
		public static var _width:Number;
		public static var _height:Number;
		
		public var groundY:Number;
		public var sprite:CCSprite;
		
		protected var velY:int = 0;
		protected var gravity:Number = 1;
		protected var isJumping:Boolean = false;
		
		public function Enemy(frameCache:CCSpriteFrameCache) 
		{	
			//Share a static animation with all enemies, no need to do this for each instance
			if (!animation) {
				var frameList = CCArray.array();
				var frameName:String, spriteFrame:CCSpriteFrame;
				
				//Create animated sprite
				for (var i = 0, l = 18; i < l; i++) {
					//Add frames Runner.swf/0000 - Runner.swf/0015
					frameName = (i >= 10? "Enemy.swf/00" : "Enemy.swf/000") + i;
					spriteFrame = frameCache.spriteFrameByName(frameName);
					frameList.addObject(spriteFrame);
				}
				animation = CCAnimation.animationWithSpriteFrames(frameList, 1 / 24);
				animation.setLoops( -1);
				
				//Extract width and height of this image for later
				_width = spriteFrame.getRectInPixels().width;
				_height = spriteFrame.getRectInPixels().height;	
			}
			
			sprite = CCSprite.create();
			sprite.runAction(CCAnimate.create(animation));
			sprite.setAnchorPoint(new CCPoint(0, 0));
			
		}
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function get x():Number { return sprite.x; }
		public function set x(value:Number){ sprite.x = value; }
		
		public function get y():Number { return sprite.y; }
		public function set y(value:Number){ sprite.y = value; }
		
		
		public function enter(root:CCNode):void {
			root.addChild(sprite);
		}
		
		public function update():void {
			velY -= gravity;
			y += velY; 
			if(y < groundY){
				y = groundY;
				isJumping = false;
				velY = 0;
			}
			
			if(!isJumping){// && sprite.y == groundY && Math.random() < .5){
				velY = height * .25;
				isJumping = true;
			}
		}
		
	}
	
}