package  
{
	import cocos2d.CCLayer;
	import cocos2d.CCNode;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrameCache;
	import UI.AtlasSprite;
	
	public class ScrollingImage
	{
		
		protected var viewWidth:Number;
		protected var viewHeight:Number;
		
		protected var images:Vector.<CCSprite>;
		protected var imageWidth:Number;
		protected var imageHeight:Number;
		protected var imageScale:Number;
		
		public function enter(root:CCNode):void {
			for (var i = 0, l = images.length; i < l; i++) {
				root.addChild(images[i]);
			}
		}
		
		public function ScrollingImage(imageName:String, width:Number, height:Number) {
			
			viewWidth = width;
			viewHeight = height;
			
			var frameCache = CCSpriteFrameCache.sharedSpriteFrameCache();
			var s = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName(imageName));
			
			//Cache the image sizes and calculate the scale to fill the viewHeight.
			imageWidth = s.displayFrame().getRectInPixels().width;
			imageHeight = s.displayFrame().getRectInPixels().height;
			imageScale = viewHeight / imageHeight;
			
			//Layout a strip of images, double the specified width.
			images = [];
			var numImages = Math.ceil((viewWidth + imageWidth) / imageWidth);
			for (var i = 0; i < numImages; i++) {
				s = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName(imageName));
				s.setAnchorPoint(new CCPoint(0, 0));
				s.retain();
				s.x = imageWidth * i * imageScale;
				s.setScale(imageScale);
				images.pushSingle(s);
			}
		}
		
		
		
		public function scroll(distance:Number):void {
			
			var i:int, l:int = images.length;
			for (i = 0; i < l; i++) {
				images[i].x -= distance;
			}
			
			//Loop?
			if (images[0].x < -imageWidth * imageScale) {
				for (i = 0; i < l; i++) {
					images[i].x = imageWidth * i * imageScale;
				}
			}
			
			
			
		}
		
	}
	
}