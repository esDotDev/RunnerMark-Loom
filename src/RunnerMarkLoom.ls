package
{
	import cocos2d.CCAction;
	import cocos2d.CCAnimate;
	import cocos2d.CCAnimation;
	import cocos2d.CCArray;
	import cocos2d.CCNode;
	import cocos2d.CCPoint;
	import cocos2d.CCSpriteBatchNode;
	import cocos2d.CCSpriteFrame;
	import cocos2d.CCSpriteFrameCache;
	import cocos2d.Cocos2D;
    import cocos2d.Cocos2DGame;
    import cocos2d.CCSprite;
    import cocos2d.ScaleMode;
	import Loom.GameFramework.TimeManager;
	import UI.AtlasSprite;

    import UI.Label;
	import UI.Atlas;

    public class RunnerMarkLoom extends Cocos2DGame
    {
		protected static const SPEED:Number = .33;
		
		public static var width:int;
		public static var height:int;
		
		[Inject]
		public var time:TimeManager;
		
		protected var fpsMeter:FpsMeter;
		
		protected var frameCache:CCSpriteFrameCache;
		protected var batchLayer:CCSpriteBatchNode;
		
		protected var enemyList:Vector.<Enemy>
		protected var particleList:Vector.<CCSprite>
		
		protected var groundList:Vector.<GroundPiece>
		protected var groundY:Number;
		protected var lastGroundPiece:GroundPiece;
		
		//Entities
		protected var runner:Runner;
		protected var hill1:ScrollingImage;
		protected var hill2:ScrollingImage;
		
        override public function run():void
        {
            // Comment out this line to turn off automatic scaling.
            //layer.scaleMode = ScaleMode.LETTERBOX;

            super.run();
			
			width = Cocos2D.getDisplayWidth();
			height = Cocos2D.getDisplayHeight();
			time.addTickedObject(this);
			
			//Simple class for tracking our elapsed time and current FPS
			fpsMeter = new FpsMeter(time);
			
			//Create shared frameCache from our SpriteSheet
			frameCache = CCSpriteFrameCache.sharedSpriteFrameCache();
			frameCache.addSpriteFramesWithFile("assets/RunnerMark.plist", "assets/RunnerMark.png");
			
			//Create batched node for normal sprites
			batchLayer = CCSpriteBatchNode.create("assets/RunnerMark.png", 2000);
			layer.addChild(batchLayer);
			
			//Add sky and stretch to fill stage
			var sky = createFrameSprite("sky.png");
			sky.setScaleX(width / sky.displayFrame().getRectInPixels().width);
			batchLayer.addChild(sky);
			
			//Add a couple of scrolling hills
			hill1 = new ScrollingImage(frameCache, "bg1.png", width, height * .5);
			hill1.enter(batchLayer);
			
			hill2 = new ScrollingImage(frameCache, "bg2.png", width, height * .5);
			hill2.enter(batchLayer);
			
			//Create an initial strip of ground pieces
			groundList = [];
			addGround(3);
			groundY = groundList[0].height * .9; 
			
			//Create the "Runner" animation
			runner = new Runner(frameCache);
			runner.sprite.y = groundY; //Inject yPos of the ground
			runner.enter(layer);
			
			//Create Dust particles
			addParticles(32);
			
        }
		
		public function onTick():void {
			hill1.scroll(1 * fpsMeter.frameFactor);
			hill2.scroll(2 * fpsMeter.frameFactor);
			
			updateGround(fpsMeter.elapsed);
			updateParticles(fpsMeter.elapsed);
			updateEnemies(fpsMeter.elapsed);
			
			if (fpsMeter.tickCount % 10 == 0) {
				addEnemies(1);
			}
			
		}
		
	/********************************************************************************************
	 * ENEMIES
	 ********************************************************************************************/
		public function addEnemies(numEnemies:int = 1):void {
			if (!enemyList) { enemyList = []; }
			var enemy:Enemy;
			for(var i:int = 0; i < numEnemies; i++){
				enemy = new Enemy(frameCache);
				enemy.enter(layer);
				enemy.y = height;
				enemy.x = width * 1.2;
				enemy.groundY = groundY;
				enemyList.pushSingle(enemy);
			}
		}
		
		protected function updateEnemies(elapsed:Number):void { 
			if (!enemyList) { return; }
			var enemy:Enemy;
			for(var i:int = enemyList.length-1; i >= 0; i--){
				enemy = enemyList[i];
				enemy.x -= elapsed * .33;
				enemy.update();
				//Loop to other edge of screen
				if(enemy.x < -enemy.width){
					enemy.x = width + 20;
				}
			}
		}
		
	/********************************************************************************************
	 * GROUND
	 ********************************************************************************************/
		
		protected function addGround(numPieces:int, height:int = 0):void {
			var lastX:int = 0;
			if(lastGroundPiece){
				lastX = lastGroundPiece.x + lastGroundPiece.width - 3;
			}
			var piece:GroundPiece;
			for(var i = 0; i < numPieces; i++){
				piece = new GroundPiece(frameCache);
				piece.enter(batchLayer);
				piece.x = lastX;
				piece.y = height;
				lastX += (piece.width - 3);
				groundList.push(piece);
			}
			if(height == 0){ lastGroundPiece = piece; }
		}
		
		
		protected function updateGround(elapsed:Number):void {
			//Add platforms
			if(fpsMeter.tickCount % (fpsMeter.fps > 30? 100 : 50) == 0){
				addGround(1, height * .25 + height * .5 * Math.random());
			}
			//Move Ground
			var ground:GroundPiece;
			for(var i = groundList.length - 1; i >= 0; i--){
				ground = groundList[i];
				ground.x -= elapsed * SPEED;
				ground.x = ground.x
					
				//Remove ground
				if(ground.x < -ground.width * 3){
					groundList.splice(i, 1);
					ground.exit();
					//putSprite(ground);
					//if(ground.display.parent){
						//ground.display.parent.removeChild(ground.display);
					//}
				}
			}
			//Add Ground
			var lastX:int = (lastGroundPiece)? lastGroundPiece.x + lastGroundPiece.width : 0;
			if(lastX < width){
				addGround(1, 0);
			}
		}

	/********************************************************************************************
	 * PARTICLES
	 ********************************************************************************************/

		protected function addParticles(numParticles:int):void {
			if(!particleList){ particleList = []; }
			
			for(var i = 0; i < numParticles; i++){
				var p:CCSprite = createFrameSprite("cloud.png");
				p.x = runner.x - 10;
				p.y = groundY + runner.height * .15  -  runner.height * .25 * Math.random();
				//Console.print(p.y);
				particleList.push(p);
				batchLayer.addChild(p);
			}
		}
		
		protected function updateParticles(elapsed:Number):void {
			if(fpsMeter.tickCount % 3 == 0){
				addParticles(3);
			}
			//Move Particles
			var p:CCSprite;
			for(var i:int = particleList.length-1; i >= 0; i--){
				p = particleList[i];
				p.x -= elapsed * SPEED * .5;
				p.setOpacity(p.getOpacity() * .95);
				
				p.setScale(p.getScale() - .02);
				//Remove Particle
				if(p.getOpacity() <= 20 || p.getScale() <= 0){
					particleList.splice(i, 1);
					if(p.getParent()){
						p.getParent().removeChild(p);
					}
				}
			}
		}
		
	/********************************************************************************************
	 * MISC
	 ********************************************************************************************/
		public function createFrameSprite(texture:String, topLeft:Boolean = true):CCSprite {
			var s = CCSprite.createWithSpriteFrame(frameCache.spriteFrameByName(texture));
			if(topLeft){
				s.setAnchorPoint(new CCPoint(0, 0));
			}
			return s;
		}
    }
}