package  
{
	import cocos2d.*;
	
	public class GroundPiece
	{	
		protected var sprite:CCSprite;
		
		public var width:int;
		public var height:int;
		
		public function GroundPiece(frameCache:CCSpriteFrameCache){	
			sprite = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName("groundTop.png"));
			sprite.setAnchorPoint(new CCPoint(0, 0));
			
			width = sprite.displayFrame().getRectInPixels().width;
			height = sprite.displayFrame().getRectInPixels().height;
		}
		
		public function enter(root:CCNode):void {
			root.addChild(sprite);
		}
		
		public function exit():void {
			if (sprite.getParent()) {
				sprite.getParent().removeChild(sprite);
			}
		}
		
		public function get x():Number{ return sprite.x; }
		public function set x(value:Number):void {
			sprite.x = value;
		}
		
		public function get y():Number{ return sprite.y; }
		public function set y(value:Number):void {
			sprite.y = value;
		}
		
	}
	
}