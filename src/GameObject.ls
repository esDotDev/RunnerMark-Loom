package  
{
	import cocos2d.CCSprite;
	import cocos2d.CCNode;
	
	public class GameObject 
	{
		public var sprite:CCSprite;
		
		protected var parent:CCNode;
		protected var _width:Number;
		protected var _height:Number;
		
		public function GameObject() {}
		
		public function get width():Number { return _width; }
		public function get height():Number { return _height; }
		
		public function enter(parent:CCNode):void {
			this.parent = parent;
			if (sprite) { parent.addChild(sprite); }
		}
		
		public function exit():void {
			if(sprite && sprite.getParent()){
				parent.removeChild(sprite);
			}
			parent = sprite = null;
		}
	}
	
}