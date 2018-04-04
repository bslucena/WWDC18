import SpriteKit
import GameplayKit

public class GameScene: SKScene {
    
    let boatSize: CGRect
    let background = SKSpriteNode(imageNamed: "background")
    let HUD = SKSpriteNode(imageNamed: "HUD")
    let hudLabel = SKLabelNode(fontNamed: "Helvetica")
    let buttonPickUp = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonForce = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonKick = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonDrop = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonCannonBallPile = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 350, height: 200))
    let buttonTreasureChest = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 350, height: 200))
    let buttonCannon = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 750, height: 375))
    let forceBar = SKSpriteNode(imageNamed: "forceBar")
    let indicator1 = SKSpriteNode(imageNamed: "increaseForce")
    let indicator2 = SKSpriteNode(imageNamed: "increaseForce")
    let indicator3 = SKSpriteNode(imageNamed: "increaseForce")
    var forceLevel = 0
    let buttonIncreaseForce = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 50, height: 50))
    let buttonDecreaseForce = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 50, height: 50))
    var force = CGVector(dx: 0, dy: 0)
    let buttonBeachBall = SKSpriteNode(imageNamed: "beachBall")
    let cannonBall = SKSpriteNode(imageNamed: "cannonBall")
    let miniCannonBall = SKSpriteNode(imageNamed: "cannonBallMini")
    let beachBall = SKSpriteNode(imageNamed: "beachBall")
    let miniBeachBall = SKSpriteNode(imageNamed: "beachBallMini")
    let miniTreasureChest = SKSpriteNode(imageNamed: "chestMini")
    let miniCannon = SKSpriteNode(imageNamed: "cannonMini")
    let boat = SKSpriteNode(imageNamed: "insideBoatBackground")
    var pirate = SKSpriteNode(imageNamed: "pirateIdle")
    var pirateTalkLabel = SKLabelNode(fontNamed: "Helvetica")
    let pirateAnimation: SKAction
    var rotation = CGFloat(0.2)
    var balls: [SKNode] = []
    var cannonIsInInventory = false
    var cannonBallIsInInventory = false
    var beachBallIsInInventory = false
    var treasureChestIsInInventory = false
    var pickUpThings = false
    var dropThings = false
    var currentBall = "none"
    
    public override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        boatSize = CGRect(x: -1024, y: -575, width: size.width, height: playableHeight)
        
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "pirateWalking\(i)"))
        }
        pirateAnimation = SKAction.animate(with: textures,
                                           timePerFrame: 0.1)
        super.init(size: size)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func didMove(to view: SKView) {
        background.anchorPoint = CGPoint.zero
        background.position = CGPoint.zero
        background.zPosition = -10
        addChild(background)
        
        HUD.anchorPoint = CGPoint.zero
        HUD.position = CGPoint(x: 0, y: 0)
        HUD.zPosition = 110
        addChild(HUD)
        
        buttonPickUp.anchorPoint = CGPoint.zero
        buttonPickUp.position = CGPoint(x: 22, y: 90)
        buttonPickUp.zPosition = 111
        buttonPickUp.name = "pickUp"
        HUD.addChild(buttonPickUp)
        
        buttonKick.anchorPoint = CGPoint.zero
        buttonKick.position = CGPoint(x: 262, y: 90)
        buttonKick.zPosition = 111
        buttonKick.name = "kick"
        HUD.addChild(buttonKick)
        
        buttonDrop.anchorPoint = CGPoint.zero
        buttonDrop.position = CGPoint(x: 523, y: 90)
        buttonDrop.zPosition = 111
        buttonDrop.name = "drop"
        HUD.addChild(buttonDrop)
        
        buttonForce.anchorPoint = CGPoint.zero
        buttonForce.position = CGPoint(x: 784, y: 90)
        buttonForce.zPosition = 111
        buttonForce.name = "force"
        HUD.addChild(buttonForce)
        
        forceBar.anchorPoint = CGPoint.zero
        forceBar.position = CGPoint(x: 764, y: 190)
        forceBar.zPosition = 111
        forceBar.name = "forceBar"
        forceBar.isHidden = true
        HUD.addChild(forceBar)
        
        buttonIncreaseForce.anchorPoint = CGPoint.zero
        buttonIncreaseForce.position = CGPoint(x: 219, y: -5)
        buttonIncreaseForce.zPosition = 112
        buttonIncreaseForce.name = "buttonIncreaseForce"
        forceBar.addChild(buttonIncreaseForce)
        
        buttonDecreaseForce.anchorPoint = CGPoint.zero
        buttonDecreaseForce.position = CGPoint(x: -15, y: -5)
        buttonDecreaseForce.zPosition = 112
        buttonDecreaseForce.name = "buttonDecreaseForce"
        forceBar.addChild(buttonDecreaseForce)
        
        indicator1.position = CGPoint(x: 45, y: 0)
        indicator1.anchorPoint = CGPoint.zero
        indicator1.zPosition = 112
        indicator1.isHidden = true
        forceBar.addChild(indicator1)
        
        indicator2.position = CGPoint(x: 100, y: 0)
        indicator2.anchorPoint = CGPoint.zero
        indicator2.zPosition = 112
        indicator2.isHidden = true
        forceBar.addChild(indicator2)
        
        indicator3.position = CGPoint(x: 155, y: 0)
        indicator3.anchorPoint = CGPoint.zero
        indicator3.zPosition = 112
        indicator3.isHidden = true
        forceBar.addChild(indicator3)
        
        hudLabel.text = "What to do?"
        hudLabel.fontColor = #colorLiteral(red: 0.4470588235, green: 0.1607843137, blue: 0.4431372549, alpha: 1)
        hudLabel.fontSize = 64
        hudLabel.zPosition = 150
        hudLabel.horizontalAlignmentMode = .center
        hudLabel.verticalAlignmentMode = .top
        hudLabel.position = CGPoint(x: 512, y: 245)
        HUD.addChild(hudLabel)
        
        boat.size = CGSize(width: boatSize.width, height: boatSize.height)
        boat.position = CGPoint(x: 1024, y: 768)
        boat.zPosition = -1
        let boatFloor = SKSpriteNode(color: UIColor.clear, size: CGSize(width: boatSize.width, height: 200))
        boatFloor.position = CGPoint(x: 0, y: -475)
        boatFloor.zPosition = 1
        addChild(boat)
        boat.addChild(boatFloor)
        boat.physicsBody = SKPhysicsBody(edgeLoopFrom: boatSize)
        boatFloor.physicsBody = SKPhysicsBody(rectangleOf: boatFloor.size)
        boatFloor.physicsBody?.isDynamic = false
        rockTheBoat(node: boat)
        
        buttonCannonBallPile.anchorPoint = CGPoint.zero
        buttonCannonBallPile.position = CGPoint(x: 25, y: -200)
        buttonCannonBallPile.zPosition = 100
        buttonCannonBallPile.name = "cannonBallPile"
        boat.addChild(buttonCannonBallPile)
        
        buttonTreasureChest.anchorPoint = CGPoint.zero
        buttonTreasureChest.position = CGPoint(x: -175, y: -305)
        buttonTreasureChest.zPosition = 102
        buttonTreasureChest.name = "treasureChest"
        boat.addChild(buttonTreasureChest)
        
        buttonCannon.anchorPoint = CGPoint.zero
        buttonCannon.position = CGPoint(x: -875, y: -305)
        buttonCannon.zPosition = 101
        buttonCannon.name = "cannon"
        boat.addChild(buttonCannon)
        
        buttonBeachBall.anchorPoint = CGPoint.zero
        buttonBeachBall.position = CGPoint(x: -800, y: -305)
        buttonBeachBall.zPosition = 102
        buttonBeachBall.name = "beachBall"
        boat.addChild(buttonBeachBall)
        
        pirate.position = CGPoint(x: -562, y: -75)
        pirate.zPosition = 104
        boat.addChild(pirate)
        pirate.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "pirateIdle"), size: pirate.size)
        pirate.physicsBody?.isDynamic = false
        
        pirateTalkLabel.text = ""
        pirateTalkLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pirateTalkLabel.fontSize = 64
        pirateTalkLabel.zPosition = 150
        pirateTalkLabel.horizontalAlignmentMode = .right
        pirateTalkLabel.verticalAlignmentMode = .center
        pirateTalkLabel.position = CGPoint(x: 875, y: 245)
        pirate.addChild(pirateTalkLabel)
        
        cannonBall.size = CGSize(width: 100, height: 100)
        cannonBall.position =  CGPoint(x: 562, y: -145)
        cannonBall.zPosition = 1
        cannonBall.physicsBody = SKPhysicsBody(circleOfRadius: cannonBall.size.width/2)
        cannonBall.physicsBody?.density = 200
        cannonBall.name = "ball"
        beachBall.size = CGSize(width: 200, height: 200)
        beachBall.position =  CGPoint(x: 502, y: -145)
        beachBall.zPosition = 1
        beachBall.physicsBody = SKPhysicsBody(circleOfRadius: beachBall.size.width/2)
        beachBall.physicsBody?.density = 0.11
        beachBall.name = "ball"
        
    }
    
    public override func update(_ currentTime: TimeInterval) {
        
        
    }
    
    func rockTheBoat(node: SKSpriteNode) {
        let rockRight = SKAction.rotate(toAngle: 0.017, duration: 1.5)
        let rockLeft = SKAction.rotate(toAngle: -0.017, duration: 1.5)
        let wait = SKAction.wait(forDuration: 2)
        let rockTheBoat = [rockRight, wait, rockLeft, wait]
        node.run(SKAction.repeatForever(SKAction.sequence(rockTheBoat)))
    }
    
    func applyForce() {
        if forceLevel == 0 {
            force = CGVector(dx: 5000, dy: 5000)
        }
        if forceLevel == 1 {
            force = CGVector(dx: 50000, dy: 50000)
        }
        if forceLevel == 2 {
            force = CGVector(dx: 500000, dy: 500000)
        }
        if forceLevel == 3 {
            force = CGVector(dx: 5000000, dy: 500000)
        }
        boat.enumerateChildNodes(withName: "ball") { (node, _) in
            node.physicsBody!.applyForce(self.force)
        }
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.pressButton(atPoint: touch.location(in: self))
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchUp(atPoint: touch.location(in: self))
    }
    
    func pressButton(atPoint pos: CGPoint) {
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "kick" {
            hudLabel.text = "Kick"
            forceBar.isHidden = true
            kick()
            return
        }
        if touchedNode.name == "pickUp" {
            hudLabel.text = "Pick Up"
            pickUpThings = true
            forceBar.isHidden = true
            return
        }
        if touchedNode.name == "drop" {
            hudLabel.text = "Drop"
            dropThings = true
            forceBar.isHidden = true
            self.currentBall = "none"
            return
        }
        if touchedNode.name == "force" {
            hudLabel.text = "Increase Force:"
            forceBar.isHidden = false
            return
        }
        if touchedNode.name == "buttonIncreaseForce" {
            if forceLevel == 0 {
                forceLevel += 1
                indicator1.isHidden = false
                
            } else if forceLevel == 1 {
                forceLevel += 1
                indicator2.isHidden = false
                
            } else if forceLevel == 2 {
                forceLevel += 1
                indicator3.isHidden = false
                
            }
            return
        }
        if touchedNode.name == "buttonDecreaseForce" {
            if forceLevel == 1 {
                forceLevel -= 1
                indicator1.isHidden = true
                
            } else if forceLevel == 2 {
                forceLevel -= 1
                indicator2.isHidden = true
                
            } else if forceLevel == 3 {
                forceLevel -= 1
                indicator3.isHidden = true
                
            }
            return
        }
        
        if touchedNode.name == "cannonBallPile" && pickUpThings == true {
            if cannonBallIsInInventory == false {
                hudLabel.text = "What to do?"
                miniCannonBall.anchorPoint = CGPoint.zero
                miniCannonBall.position = CGPoint(x: 1244, y: 90)
                miniCannonBall.zPosition = 112
                miniCannonBall.name = "miniCannonBall"
                HUD.addChild(miniCannonBall)
                cannonBallIsInInventory = true
                pickUpThings = false
            } else if pickUpThings == true {
                pirateTalkLabel.text = "I already have that."
                pirateTalkLabel.position = CGPoint(x: 625, y: 245)
            }
            
            return
        }
        if touchedNode.name == "treasureChest" {
            if treasureChestIsInInventory == false && pickUpThings == true {
                hudLabel.text = "What to do?"
                miniTreasureChest.anchorPoint = CGPoint.zero
                miniTreasureChest.position = CGPoint(x: 1414, y: 80)
                miniTreasureChest.zPosition = 112
                miniTreasureChest.name = "miniTreasureChest"
                HUD.addChild(miniTreasureChest)
                pirateTalkLabel.text = "This chest fits perfectly in my pocket."
                treasureChestIsInInventory = true
                pickUpThings = false
            } else if pickUpThings == true {
                pirateTalkLabel.text = "I already have that."
                pirateTalkLabel.position = CGPoint(x: 625, y: 245)
            }
            return
        }
        if touchedNode.name == "cannon" {
            if cannonIsInInventory == false && pickUpThings == true {
                hudLabel.text = "What to do?"
                miniCannon.anchorPoint = CGPoint.zero
                miniCannon.position = CGPoint(x: 1634, y: 80)
                miniCannon.zPosition = 112
                miniCannon.name = "miniCannon"
                HUD.addChild(miniCannon)
                pirateTalkLabel.text = "Aye, I will put this in my pocket."
                cannonIsInInventory = true
                pickUpThings = false
            } else if pickUpThings == true {
                pirateTalkLabel.text = "I already have that."
                pirateTalkLabel.position = CGPoint(x: 625, y: 245)
            }
            return
        }
        if touchedNode.name == "beachBall" {
            if beachBallIsInInventory == false && pickUpThings == true {
                hudLabel.text = "What to do?"
                miniBeachBall.anchorPoint = CGPoint.zero
                miniBeachBall.position = CGPoint(x: 1824, y: 75)
                miniBeachBall.zPosition = 113
                miniBeachBall.name = "miniBeachBall"
                HUD.addChild(miniBeachBall)
                beachBallIsInInventory = true
                pickUpThings = false
                
                pirateTalkLabel.text = "Pirates also deserve fun, right?"
                pirateTalkLabel.position = CGPoint(x: 925, y: 245)
            } else if pickUpThings == true {
                pirateTalkLabel.text = "I already have that."
                pirateTalkLabel.position = CGPoint(x: 625, y: 245)
            }
            return
        }
        if touchedNode.name == "miniCannonBall" && dropThings == true {
            addBall(ball: "cannonBall")
            dropThings = false
            hudLabel.text = "What to do?"
            currentBall = "cannonBall"
            return
        }
        if touchedNode.name == "miniBeachBall" && dropThings == true {
            addBall(ball: "beachBall")
            dropThings = false
            hudLabel.text = "What to do?"
            currentBall = "beachBall"
            return
        }
        if touchedNode.name == "miniTreasureChest" && dropThings == true {
            pirateTalkLabel.text = "Nah, I might need that later."
            pirateTalkLabel.position = CGPoint(x: 875, y: 245)
            
            dropThings = false
            hudLabel.text = "What to do?"
        }
        if touchedNode.name == "miniCannon" && dropThings == true {
            pirateTalkLabel.text = "Nah, I might need that later."
            pirateTalkLabel.position = CGPoint(x: 875, y: 245)
            
            dropThings = false
            hudLabel.text = "What to do?"
        }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "kick" {
            return
        }
        
    }
    
    func kick() {
        if balls != [] {
            
            startAnimation()
            let ball = balls[0]
            let move = SKAction.moveTo(x: ball.position.x - 150, duration: 0.6)
            move.timingMode = .easeOut
            let wait = SKAction.wait(forDuration: 0.05)
            let kickBall = SKAction.run {
                self.applyForce()
            }
            let stop = SKAction.run {
                self.stopAnimation()
                
            }
            let reset = SKAction.run {
                self.boat.enumerateChildNodes(withName: "ball") { (node, _) in
                    node.removeFromParent()
                }
                self.pirate.removeFromParent()
                self.pirate.position = CGPoint(x: -562, y: -75)
                self.pirate.zPosition = 103
                self.pirate.texture = SKTexture(imageNamed: "pirateIdle")
                self.boat.addChild(self.pirate)
                self.balls = []
                
                
            }
            let speak = SKAction.run {
                if self.currentBall == "cannonBall" && self.forceLevel == 0 {
                    self.pirateTalkLabel.text = "It didn't move at all."
                } else if self.currentBall == "cannonBall" && self.forceLevel <= 2 {
                    self.pirateTalkLabel.text = "It barely move"
                } else {
                    self.pirateTalkLabel.text = "Nice kick!"
                }
            }
            let finish = SKAction.wait(forDuration: 1.25)
            let act = [move, wait, kickBall, stop, finish, reset, speak]
            pirate.run(SKAction.sequence(act))
            
            
        }
        
        
    }
    
    func addBall(ball: String) {
        if balls == [] {
            if ball == "beachBall" {
                beachBall.zPosition = 102
                beachBall.position =  CGPoint(x: 502, y: -145)
                boat.addChild(beachBall)
                boat.enumerateChildNodes(withName: "ball") { (node, _) in
                    self.balls.append(node)
                }
            } else if ball == "cannonBall" {
                cannonBall.zPosition = 102
                cannonBall.position =  CGPoint(x: 502, y: -145)
                boat.addChild(cannonBall)
                boat.enumerateChildNodes(withName: "ball") { (node, _) in
                    self.balls.append(node)
                }
            }
        }
    }
    
    func startAnimation() {
        if pirate.action(forKey: "animation") == nil {
            pirate.run(
                SKAction.repeatForever(pirateAnimation),
                withKey: "animation")
        }
        
    }
    
    func stopAnimation() {
        pirate.removeAction(forKey: "animation")
    }
    
}
