//
//  GameScene.swift
//  ProjectGame1
//
//  Created by saurav sehgal(991460942).
//  Copyright © 2019 Xcode User. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let enemySpaceship : UInt32 = 0b1
    static let spaceship : UInt32 = 0b10
    static let Projectile : UInt32 = 0b11
    static let bullet : UInt32 = 0b1100
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //All the relevant variables need for the game to operate
    private var spaceship : SKSpriteNode?
    private var explosion : SKSpriteNode?
    private var spaceshipBullet : SKSpriteNode?
    private var enemySpaceship : SKSpriteNode?
    private var startGameButton: SKSpriteNode?
    private var lastUpdateTime : TimeInterval = 0
    private var spaceshipFrames: [SKTexture] = []
    private var textureAtlas = SKTextureAtlas()
    private var explosionFrames: [SKTexture] = []
    private var explosiontextureAtlas = SKTextureAtlas()
    private var enemySpaceshipFrames: [SKTexture] = []
    private var enemySpaceshiptextureAtlas = SKTextureAtlas()
    private var score : Int?
    let scoreRefCount = 10
    private var lbScore : SKLabelNode?
    
    override func didMove(to view: SKView) {
        //Add start button on load
        addStartButton()
    }
    
    //This function sets all the nodes and animations
    func startGame(){
        score = 0
        self.lbScore = (self.childNode(withName: "//scoreLabel") as! SKLabelNode)
        self.lbScore?.fontSize = 42
        self.lbScore?.fontName = "AmericanTypeWriter-Bold"
        self.lbScore?.fontColor = UIColor.red
        self.lbScore?.text = "Score: \(score!)"
        
        if let slabel = self.lbScore {
            slabel.alpha = 0
            slabel.run(SKAction.fadeIn(withDuration: 1.0))
        }
        
        startGameButton?.removeFromParent()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //Add the spaceship and animations for it
        addSpaceship()
        
        spaceshipBullet = SKSpriteNode(imageNamed: "bullet.png")
        spaceshipBullet?.position = CGPoint(x:0, y:-400)
        spaceshipBullet?.scale(to: CGSize.init(width: 150.0, height: 130.0))

        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(backgroundStars), SKAction.wait(forDuration: 0.07)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addEnemySpaceships), SKAction.wait(forDuration: 0.5)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addBullet), SKAction.wait(forDuration: 0.3)])))
    }
  
    //This function adds the spaceship and its animations needed as a GIF file
    func addSpaceship(){
        textureAtlas = SKTextureAtlas(named:"Spaceship")
        for i in 1...textureAtlas.textureNames.count{
            spaceshipFrames.append(SKTexture(imageNamed:"spaceship\(i).png"))
        }
        spaceship = SKSpriteNode(imageNamed: textureAtlas.textureNames[0] as! String)
        
        spaceship?.position = CGPoint(x:0, y:-500)
        spaceship?.scale(to: CGSize.init(width: 120.0, height: 120.0))
        
        
        addChild(spaceship!)
        
        spaceship?.physicsBody = SKPhysicsBody(circleOfRadius: (spaceship?.size.width)! / 2)
        spaceship?.physicsBody?.isDynamic = true
        spaceship?.physicsBody?.categoryBitMask = PhysicsCategory.spaceship
        spaceship?.physicsBody?.contactTestBitMask = PhysicsCategory.enemySpaceship
        spaceship?.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        
       spaceship!.run(SKAction.repeatForever(SKAction.animate(with: spaceshipFrames, timePerFrame: 0.05)))
    }
    
    //This function adds the enemy spaceship and its animations needed as a GIF file
    func addEnemySpaceships(){
        enemySpaceshiptextureAtlas = SKTextureAtlas(named:"EnemySpaceship")
        for i in 1...enemySpaceshiptextureAtlas.textureNames.count{
            enemySpaceshipFrames.append(SKTexture(imageNamed:"enemySpaceship\(i).png"))
        }
        enemySpaceship = SKSpriteNode(imageNamed: enemySpaceshiptextureAtlas.textureNames[0] as! String)
        let x = random(min: -320.0, max: 400.0)
        enemySpaceship?.position = CGPoint(x:x, y:700)
        enemySpaceship?.scale(to: CGSize.init(width: 120.0, height: 120.0))
        
        addChild(enemySpaceship!)
        
        
        
        enemySpaceship!.physicsBody = SKPhysicsBody(rectangleOf: enemySpaceship!.size)
        enemySpaceship!.physicsBody?.isDynamic = true
        enemySpaceship!.physicsBody?.categoryBitMask = PhysicsCategory.enemySpaceship
        enemySpaceship!.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
        enemySpaceship!.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        enemySpaceship!.run(SKAction.repeatForever(SKAction.animate(with: enemySpaceshipFrames, timePerFrame: 0.05)))
        
        let actionMove = SKAction.move(to: CGPoint(x: spaceship!.position.x, y: -700), duration: TimeInterval(3.0))
        let actionMoveDone = SKAction.removeFromParent()
       
        
        enemySpaceship!.run(SKAction.sequence([actionMove,actionMoveDone]))
       
        
        
        
    }
    
    //This function adds the explosion GIF on screen when spaceship collides with enemy spaceship
    func addExplosion(pos:CGPoint){
        
        explosiontextureAtlas = SKTextureAtlas(named:"Explosion")
        for i in 1...explosiontextureAtlas.textureNames.count{
            explosionFrames.append(SKTexture(imageNamed:"explosion\(i).png"))
            
        }
        explosion = SKSpriteNode(imageNamed: explosiontextureAtlas.textureNames[0] as! String)
        
        explosion?.position = pos
        explosion?.scale(to: CGSize.init(width: 150.0, height: 150.0))
        addChild(explosion!)
        explosion!.run(SKAction.animate(with: explosionFrames, timePerFrame: 0.05))
        
        
    }
    
    //This function is responsible for the generation of bullets from spaceship
    func addBullet(){
        
        spaceshipBullet = SKSpriteNode(imageNamed: "bullet.png")
        let x = spaceship!.position.x
        let y = spaceship!.position.y
        spaceshipBullet!.position = CGPoint(x: x, y: y+70)
        spaceshipBullet?.scale(to: CGSize.init(width: 150.0, height: 300.0))
        addChild(spaceshipBullet!)
        
        spaceshipBullet!.physicsBody = SKPhysicsBody(circleOfRadius: (spaceshipBullet?.size.width)! / 10)
        spaceshipBullet!.physicsBody?.isDynamic = true
        spaceshipBullet!.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        spaceshipBullet!.physicsBody?.contactTestBitMask = PhysicsCategory.enemySpaceship
        spaceshipBullet!.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actionMove = SKAction.move(to: CGPoint(x: x, y: 700.0), duration: TimeInterval(1.5))
        let actionMoveDone = SKAction.removeFromParent()
        
        spaceshipBullet!.run(SKAction.sequence([actionMove,actionMoveDone]))
        
    }
   
    //Helper method
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    //Helper method
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max-min) + min
    }
    
    //Run the logic when spaceship collide with enemy spaceship
    func spaceshipDidCollideWithEnemySpaceship(spaceship :  SKSpriteNode, enemySpaceship : SKSpriteNode){
        print("hit")
       
        //Add the explosion when collided
        addExplosion(pos: enemySpaceship.position)
        
        enemySpaceship.removeFromParent()
        removeAllActions()
        run(SKAction.playSoundFileNamed("Grenade Explosion-SoundBible.com-2100581469.wav", waitForCompletion: false))
        spaceship.removeFromParent()
   
        //remove explosion frames and go back to view controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.explosionFrames = []
            self.explosiontextureAtlas = SKTextureAtlas()
            self.addStartButton()
        }
        
    }
    
    //This function contains the logic when bullet collided with enemy spaceship
    func bulletCollideWithEnemySpaceShip(enemy :  SKSpriteNode, bullet : SKSpriteNode){
        
        run(SKAction.playSoundFileNamed("Blop-Mark_DiAngelo-79054334.wav", waitForCompletion: false))
        
        //Update label
        score = score! + scoreRefCount
        self.lbScore?.text = "Score: \(score!)"
        if let slabel = self.lbScore {
            slabel.alpha = 0
            slabel.run(SKAction.fadeIn(withDuration: 1.0))
        }
        
        //Remove bullet and enemy spaceship from scene
        enemy.removeFromParent()
        bullet.removeFromParent()
        
        
    }
    
    //This function animates the background stars
    func backgroundStars(){
        let star = SKSpriteNode(imageNamed: "star.png")
        star.scale(to: CGSize.init(width: 120.0, height: 100.0))
        
        let x = random(min: -320.0, max: 400.0)
        let y = random(min: -640.0, max: 640.0)
        star.position = CGPoint(x: x, y: 700.0)
        star.scale(to: CGSize.init(width: 15.0, height: 5.0))
        addChild(star)
        let actionMove = SKAction.move(to: CGPoint(x: x, y: -700.0), duration: TimeInterval(2.0))
        let actionMoveDone = SKAction.removeFromParent()
        
        star.run(SKAction.sequence([actionMove,actionMoveDone]))
        
        
    }
    
    //This function is responsible for moving the spaceship
    func moveSpaceship(toPoint pos : CGPoint){
        let actionMove = SKAction.move(to: pos, duration: 0.1)
        spaceship?.run(SKAction.sequence([actionMove]))
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //Collission detection for spaceship and enemy spaceship
        if ((firstBody.categoryBitMask & PhysicsCategory.enemySpaceship != 0) && (secondBody.categoryBitMask & PhysicsCategory.spaceship != 0)){
            spaceshipDidCollideWithEnemySpaceship(spaceship: firstBody.node as! SKSpriteNode, enemySpaceship : secondBody.node as! SKSpriteNode)
        }
        
        //Collission detection for bullet and enemy spaceship
        if ((firstBody.categoryBitMask & PhysicsCategory.enemySpaceship != 0) && (secondBody.categoryBitMask & PhysicsCategory.bullet != 0)){
            bulletCollideWithEnemySpaceShip(enemy: secondBody.node as! SKSpriteNode, bullet : firstBody.node as! SKSpriteNode)
        }
        
        
        
    }
    
    //This function adds the start button child node in scene
    func addStartButton(){
        startGameButton = SKSpriteNode(imageNamed: "startGame.png")
        startGameButton!.position = CGPoint(x: 0, y: 0)
        startGameButton!.scale(to: CGSize.init(width: 300.0, height: 150.0))
        startGameButton!.name = "startGame"
        addChild(startGameButton!)
    }
    
    //Move spacechip
    func touchDown(atPoint pos : CGPoint) {
      
        moveSpaceship(toPoint: pos)
        
    }
    
    //Move spacechip
    func touchMoved(toPoint pos : CGPoint) {
        
        moveSpaceship(toPoint: pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
     
    }
    
    //Detect the touch on start button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches {
            
            if t == touches.first{
                enumerateChildNodes(withName: "//*") { (node, stop) in
                    if node.name == "startGame"{
                        if node.contains(t.location(in: self)){
                        print("startGame")
                            self.startGame()
                        }
                    }
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
    }
}
