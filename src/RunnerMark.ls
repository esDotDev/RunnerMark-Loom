package 
{
	import cocos2d.CCNode;
	import cocos2d.CCPoint;
	import cocos2d.CCSize;
	import cocos2d.CCSprite;
	import cocos2d.CCSpriteBatchNode;
	import cocos2d.CCSpriteFrameCache;
	import cocos2d.CCTextAlignment;
	import cocos2d.Cocos2D;
	import cocos2d.Cocos2DGame;
	import Loom.GameFramework.TimeManager;
	import UI.Atlas;
	import UI.AtlasSprite;
	import UI.Label;
	
	import esdot.runnermark.*;
	
    public class RunnerMark extends Cocos2DGame
    {
		
		public static var displayWidth:Number;
		public static var displayHeight:Number;
		
		[Inject]
		public var time:TimeManager;
		
		protected var fpsMeter:FpsMeter;
		protected var speed:Number = .33;
		protected var incrementDelay:Number = 250;
		protected var maxIncrement:Number = 12000;
		protected var lastIncrement:Number = 0;
		protected var targetFPS:Number = 55;
		protected var runnerScore:Number;
		
		//
		protected var scoreLabel:Label;
		
		//Layers
		protected var bgLayer:CCSpriteBatchNode;
		protected var enemyLayer:CCSpriteBatchNode;
		protected var runnerLayer:CCSpriteBatchNode;
		
		protected var enemyList:Vector.<Enemy> = [];
		protected var particleList:Vector.<CCSprite> = [];
		
		//Ground
		protected var groundPool:Vector.<GroundPiece> = [];
		protected var groundList:Vector.<GroundPiece> = [];
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
			
			//Register/Load TextureAtlas
			Atlas.register("RunnerMark", "assets/");
			
			//Create a few layers to hold our different game objects
			bgLayer = CCSpriteBatchNode.create("assets/RunnerMark.png", 1000);
			layer.addChild(bgLayer);
			
			enemyLayer = CCSpriteBatchNode.create("assets/RunnerMark.png", 2000);
			layer.addChild(enemyLayer);
			
			runnerLayer = CCSpriteBatchNode.create("assets/RunnerMark.png", 500);
			layer.addChild(runnerLayer);
			
			//Add Bg for the Score Text
			var scoreBg = createAtlasSprite("topBg.png");
			scoreBg.y = displayHeight - scoreBg.displayFrame().getRectInPixels().height;
			scoreBg.setScaleX(displayWidth / scoreBg.displayFrame().getRectInPixels().width);
			layer.addChild(scoreBg);
			
			scoreLabel = new Label("assets/Curse-hd.fnt");
			
			scoreLabel.text = "SCORE: __";
			scoreLabel.x = 200;
			scoreLabel.y = displayHeight - scoreBg.displayFrame().getRectInPixels().height * .25;
			scoreLabel.setScale(.5);
			layer.addChild(scoreLabel);
			
			//Create Sky
			var sky = createAtlasSprite("sky.png");
			sky.setScaleX(displayWidth / sky.displayFrame().getRectInPixels().width);
			bgLayer.addChild(sky);
			
			//Add a couple of scrolling hills
			hill1 = new ScrollingImage("bg1.png", displayWidth, displayHeight * .5);
			hill1.enter(bgLayer);
			
			hill2 = new ScrollingImage("bg2.png", displayWidth, displayHeight * .5);
			hill2.enter(bgLayer);
			
			//Create an initial strip of ground pieces
			addGround(3);
			groundY = groundList[0].height * .85; 
			
			//Create the "Runner" animation
			runner = new Runner();
			runner.groundY = groundY;
			runner.enemyList = enemyList;
			runner.sprite.x = RunnerMark.displayWidth * .15;
			runner.sprite.y = groundY;
			runner.enter(runnerLayer);
			
			//Create Dust particles
			addParticles(32);
			
        }
		
		public function onTick():void {
			hill1.scroll(1 * fpsMeter.frameFactor);
			hill2.scroll(2 * fpsMeter.frameFactor);
			
			runner.update(fpsMeter.elapsed);
			updateGround(fpsMeter.elapsed);
			updateParticles(fpsMeter.elapsed);
			updateEnemies(fpsMeter.elapsed);
			
			//Get Score
			if(enemyList.length > 0){
				runnerScore = Math.round(targetFPS * 10 + enemyList.length);
			} else {
				runnerScore = Math.round(fpsMeter.fps * 10);
			}
			if (fpsMeter.tickCount % 60 == 0) {
				scoreLabel.text = "score: " + runnerScore;
			}
			
			//Check whether to add more enemies, or end test.
			var increment:Number = fpsMeter.totalTime - lastIncrement;
			if(fpsMeter.fps >= targetFPS && increment > incrementDelay){
				addEnemies(1 + Math.floor(enemyList.length/50));
				lastIncrement = fpsMeter.totalTime;
			} 
			else if(increment > maxIncrement){
				showTestComplete();
			}
			
		}
		
		protected function showTestComplete() {
			time.removeTickedObject(this);
			
			var popUp = createAtlasSprite("scoreBg.png");
			popUp.setAnchorPoint(new CCPoint(.5, .5));
			popUp.x = displayWidth >> 1;
			popUp.y = displayHeight >> 1;
			layer.addChild(popUp);
			
			var results = new Label("assets/Curse-hd.fnt");
			results.text = "Score: " + runnerScore;
			results.x = displayWidth >> 1;
			results.y = displayHeight >> 1;
			layer.addChild(results);
			
			layer.onTouchEnded += function() {
				enemyLayer.removeAllChildrenWithCleanup(true);
				enemyList.length = 0;
				
				layer.onTouchEnded = null;
				layer.removeChild(popUp);
				layer.removeChild(results);
				
				fpsMeter.reset();
				time.addTickedObject(this);
			}
		}
		
	/********************************************************************************************
	 * ENEMIES
	 ********************************************************************************************/
		public function addEnemies(numEnemies:int = 1):void {
			var enemy:Enemy;
			for(var i:int = 0; i < numEnemies; i++){
				enemy = new Enemy();
				enemy.enter(enemyLayer);
				//enemy.enter(bgLayer); //This crashes, but I don't think it should...
				enemy.sprite.y = displayHeight;
				enemy.sprite.x = displayWidth;
				enemy.groundY = groundY;
				enemyList.pushSingle(enemy);
			}
		}
		
		protected function updateEnemies(elapsed:Number):void { 
			var enemy:Enemy;
			for(var i:int = enemyList.length-1; i >= 0; i--){
				enemy = enemyList[i];
				enemy.sprite.x -= elapsed * .33;
				enemy.update(elapsed);
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
			//Position any new pieces at the end of the strip, if there is one.
			var lastX:int = 0;
			if(lastGroundPiece){
				lastX = lastGroundPiece.sprite.x + lastGroundPiece.width - 3;
			}
			
			var piece:GroundPiece;
			for (var i = 0; i < numPieces; i++) {
				//Use a pooled piece if there's one available...
				if (groundPool.length > 0) {
					piece = groundPool.pop() as GroundPiece;
				}else {
					piece = new GroundPiece();
					piece.enter(bgLayer);
				}
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
				ground.sprite.x -= elapsed * speed;
					
				//Remove ground
				if(ground.sprite.x < -ground.width * 3){
					groundList.splice(i, 1);
					groundPool.pushSingle(ground);
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
			for(var i = 0; i < numParticles; i++){
				var p:AtlasSprite = createAtlasSprite("cloud.png");
				p.x = runner.sprite.x - 10;
				p.y = runner.sprite.y + runner.height * .15  -  runner.height * .25 * Math.random();
				particleList.push(p);
				runnerLayer.addChild(p);
			}
			runnerLayer.reorderChild(runner.sprite, particleList.length);
		}
		
		protected function updateParticles(elapsed:Number):void {
			if(fpsMeter.tickCount % 3 == 0){
				addParticles(3);
			}
			//Move Particles
			var p:CCSprite;
			for(var i:int = particleList.length-1; i >= 0; i--){
				p = particleList[i];
				p.x -= elapsed * speed * .5;
				p.setOpacity(p.getOpacity() * .95);
				p.setScale(p.getScale() - .02);
				//Remove Particle
				if(p.getOpacity() <= 20 || p.getScale() <= 0){
					particleList.splice(i, 1);
					p.removeFromParentAndCleanup();
				}
			}
		}
		
	/********************************************************************************************
	 * MISC
	 ********************************************************************************************/
		public static function createAtlasSprite(texture:String):AtlasSprite  {
			var s = new AtlasSprite();
			s.atlasID = "RunnerMark";
			s.texture = texture;
			s.setAnchorPoint(new CCPoint(0, 0));
			return s;
		}
		
		
    }
}