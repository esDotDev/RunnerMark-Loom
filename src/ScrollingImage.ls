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
		
		public function ScrollingImage(frameCache:CCSpriteFrameCache, imageName:String, width:Number, height:Number){
			//Create an instance of the image so we can get it's measurements
			var s = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName(imageName));
			imageWidth = s.displayFrame().getRectInPixels().width;
			imageHeight = s.displayFrame().getRectInPixels().height;
			imageScale = height / imageHeight;
			
			viewWidth = width;
			viewHeight = height;
			
			//Layout a strip of images, double the specified width.
			var numImages = Math.ceil(width / imageWidth);
			Console.print("NumImages: " + numImages);
			images = [];
			for (var i = 0; i < numImages; i++) {
				s = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName(imageName));
				s.setAnchorPoint(new CCPoint(0, 0));
				s.retain();
				images.pushSingle(s);
				s.x = imageWidth * i * imageScale;
				s.setScale(imageScale);
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