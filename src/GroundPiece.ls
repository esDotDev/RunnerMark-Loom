package  
{
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrameCache;
	
	public class GroundPiece extends GameObject
	{	
		public function GroundPiece() {	
			
			var frameCache = CCSpriteFrameCache.sharedSpriteFrameCache();
			sprite = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName("groundTop.png"));
			sprite.setAnchorPoint(new CCPoint(0, 0));
			
			_width = sprite.displayFrame().getRectInPixels().width;
			_height = sprite.displayFrame().getRectInPixels().height;
			
		}
		
	}
	
}