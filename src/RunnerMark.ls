package
{
	import cocos2d.CCNode;
	import cocos2d.CCPoint;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteBatchNode;
	import cocos2d.CCSpriteFrameCache;
	import cocos2d.Cocos2D;
	import cocos2d.Cocos2DGame;
	import Loom.GameFramework.TimeManager;

	
    public class RunnerMark extends Cocos2DGame
    {
		protected static const SPEED:Number = .33;
		
		public static var displayWidth:Number;
		public static var displayHeight:Number;
		
		[Inject]
		public var time:TimeManager;
		
		protected var fpsMeter:FpsMeter;
		protected var frameCache:CCSpriteFrameCache;
		
		//Layers
		protected var batchLayer:CCSpriteBatchNode;
		protected var enemyLayer:CCNode;
		
		protected var enemyList:Vector.<Enemy>
		protected var particleList:Vector.<CCSprite>
		
		//Ground
		protected var groundList:Vector.<GroundPiece>
		protected var groundY:Number;
		protected var lastGroundPiece:GroundPiece;
		
		//Entities
		protected var runner:Runner;
		protected var hill1:ScrollingImage;
		protected var hill2:ScrollingImage;
		
        override public function run():void {
			super.run();
			
			displayWidth = Cocos2D.getDisplayWidth();
			displayHeight = Cocos2D.getDisplayHeight();
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
			sky.setScaleX(displayWidth / sky.displayFrame().getRectInPixels().width);
			batchLayer.addChild(sky);
			
			//Add a couple of scrolling hills
			hill1 = new ScrollingImage("bg1.png", displayWidth, displayHeight * .5);
			hill1.enter(batchLayer);
			
			hill2 = new ScrollingImage("bg2.png", displayWidth, displayHeight * .5);
			hill2.enter(batchLayer);
			
			//Create an initial strip of ground pieces
			addGround(3);
			groundY = groundList[0].height * .85; 
			
			//Empty layer to hold enemies
			enemyLayer = CCNode.create();
			layer.addChild(enemyLayer);
			
			//Create the "Runner" animation
			runner = new Runner();
			runner.sprite.x = RunnerMark.displayWidth * .15;
			runner.sprite.y = groundY;
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
				enemy = new Enemy();
				enemy.enter(enemyLayer);
				//enemy.enter(batchLayer); //This crashes, but I don't think it should...
				enemy.sprite.y = displayHeight;
				enemy.sprite.x = displayWidth * 1.2;
				enemy.groundY = groundY;
				enemyList.pushSingle(enemy);
			}
		}
		
		protected function updateEnemies(elapsed:Number):void { 
			if (!enemyList) { return; }
			var enemy:Enemy;
			for(var i:int = enemyList.length-1; i >= 0; i--){
				enemy = enemyList[i];
				enemy.sprite.x -= elapsed * .33;
				enemy.update();
				//Loop to other edge of screen
				if(enemy.sprite.x < -enemy.width){
					enemy.sprite.x = displayWidth + 20;
				}
			}
		}
		
	/********************************************************************************************
	 * GROUND
	 ********************************************************************************************/
		
		protected function addGround(numPieces:int, height:int = 0):void {
			if (!groundList) { groundList = []; }
			
			//Position any new pieces at the end of the strip, if there is one.
			var lastX:int = 0;
			if(lastGroundPiece){
				lastX = lastGroundPiece.sprite.x + lastGroundPiece.width - 3;
			}
			
			var piece:GroundPiece;
			for(var i = 0; i < numPieces; i++){
				piece = new GroundPiece();
				piece.enter(batchLayer);
				piece.sprite.x = lastX;
				piece.sprite.y = height;
				lastX += (piece.width - 3);
				groundList.push(piece);
			}
			//If it's not a raised platform...
			if (height == 0) { 
				//Save the last ground piece so we know where to place the next one. 
				lastGroundPiece = piece; }
		}
		
		
		protected function updateGround(elapsed:Number):void {
			
			//Add raised platform?
			if(fpsMeter.tickCount % (fpsMeter.fps > 30? 100 : 50) == 0){
				addGround(1, displayHeight * .25 + displayHeight * .5 * Math.random());
			}
			
			//Move Ground
			var ground:GroundPiece;
			for(var i = groundList.length - 1; i >= 0; i--){
				ground = groundList[i];
				ground.sprite.x -= elapsed * SPEED;
					
				//Remove ground
				if(ground.sprite.x < -ground.width * 3){
					groundList.splice(i, 1);
					ground.exit();
					//putSprite(ground);
					//if(ground.display.parent){
						//ground.display.parent.removeChild(ground.display);
					//}
				}
			}
			//Add Ground
			var lastX:int = (lastGroundPiece)? lastGroundPiece.sprite.x + lastGroundPiece.width : 0;
			if(lastX < displayWidth){
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
				p.x = runner.sprite.x - 10;
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