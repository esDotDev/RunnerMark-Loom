package esdot.runnermark 
{
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteFrameCache;
	import UI.AtlasSprite;
	
	import RunnerMark;
	
	public class GroundPiece extends GameObject
	{	
		public function GroundPiece() {	
			
			sprite = RunnerMark.createAtlasSprite("groundTop.png");
			
			_width = sprite.displayFrame().getRectInPixels().width;
			_height = sprite.displayFrame().getRectInPixels().height;
			
		}
		
	}
	
}