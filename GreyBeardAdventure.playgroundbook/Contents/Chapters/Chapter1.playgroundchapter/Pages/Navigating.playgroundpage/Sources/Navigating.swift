import SpriteKit
import GameplayKit

public class BoatScene: SKScene {
    
    let screenSize: CGRect
    let background = SKSpriteNode(imageNamed: "blueBackground")
    let waveFront = SKSpriteNode(imageNamed: "waveForeground")
    let waveBack = SKSpriteNode(imageNamed: "waveBackground")
    let waveFront2 = SKSpriteNode(imageNamed: "waveForeground")
    let waveBack2 = SKSpriteNode(imageNamed: "waveBackground")
    let boat = SKSpriteNode(imageNamed: "boat")
    let pirate = SKSpriteNode(imageNamed: "pirateIdle")
    var pirateTalkLabel = SKLabelNode(fontNamed: "Helvetica")
    let pirateLegs = SKSpriteNode(imageNamed: "pirateLegs")
    let flag = SKSpriteNode(imageNamed: "flag")
    let flagAnimation: SKAction
    let cloud1 = SKSpriteNode(imageNamed: "cloud")
    let cloud2 = SKSpriteNode(imageNamed: "cloud")
    let cloud3 = SKSpriteNode(imageNamed: "cloud")
    var cloudSpeed: CGFloat = 10
    var cloudGenerationInterval: TimeInterval = 1.0
    var waveSpeed: CGFloat = 5
    let island = SKSpriteNode(imageNamed: "island")
    var shipCrashed = false
    var islandSpeed: CGFloat = 100
    let cameraNode = SKCameraNode()
    
    var cameraRect : CGRect {
        let x = cameraNode.position.x - size.width/2 + (size.width - screenSize.width)/2
        let y = cameraNode.position.y - size.height/2 + (size.height - screenSize.height)/2
        return CGRect(x: x, y: y, width: screenSize.width, height: screenSize.height)
    }
    
    let HUD = SKSpriteNode(imageNamed: "HUD")
    let hudLabel = SKLabelNode(fontNamed: "Helvetica")
    let buttonPickUp = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonForce = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonKick = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonDrop = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 200, height: 100) )
    let buttonCannonBallPile = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 350, height: 200))
    let buttonTreasureChest = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 350, height: 200))
    let buttonCannon = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 750, height: 375))
    let buttonBeachBall = SKSpriteNode(imageNamed: "beachBall")
    let cannonBall = SKSpriteNode(imageNamed: "cannonBall")
    let miniCannonBall = SKSpriteNode(imageNamed: "cannonBallMini")
    let beachBall = SKSpriteNode(imageNamed: "beachBall")
    let miniBeachBall = SKSpriteNode(imageNamed: "beachBallMini")
    let miniTreasureChest = SKSpriteNode(imageNamed: "chestMini")
    let miniCannon = SKSpriteNode(imageNamed: "cannonMini")
    var dropThings = false
    var thing = ""
    
    public override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        screenSize = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var textures: [SKTexture] = []
        for i in 1...2 {
            textures.append(SKTexture(imageNamed: "flag\(i)"))
        }
        flagAnimation = SKAction.animate(with: textures,
                                         timePerFrame: 0.38)
        
        super.init(size: size)
    }
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        
        island.position = CGPoint(x: 5000, y: island.size.height)
        island.size = CGSize(width: island.size.width * 1.2, height: island.size.height)
        island.zPosition = 1
        addChild(island)
        
        background.anchorPoint = CGPoint.zero
        background.zPosition = -1
        addChild(background)
        
        waveBack.position = CGPoint(x: 1024, y: 400)
        waveBack.size = CGSize(width: waveBack.size.width * 1.5, height: waveBack.size.height)
        waveBack.zPosition = 0
        addChild(waveBack)
        tide(node: waveBack, name: "waveBack")
        
        boat.size = CGSize(width: boat.size.width, height: boat.size.height * 0.75)
        boat.position = CGPoint(x: 820, y: 730)
        boat.zPosition = 2
        addChild(boat)
        rockTheBoat(node: boat)
        
        cameraNode.position = CGPoint.zero
        addChild(cameraNode)
        
        pirate.size = CGSize(width: 151, height: 254)
        pirate.position = CGPoint(x: -boat.size.width * 0.5 + 225, y: 0)
        pirate.zPosition = 2
        boat.addChild(pirate)
        
        pirateTalkLabel.text = "Let's go, to Banana Island TM!"
        pirateTalkLabel.fontColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        pirateTalkLabel.fontSize = 64
        pirateTalkLabel.zPosition = 150
        pirateTalkLabel.horizontalAlignmentMode = .right
        pirateTalkLabel.verticalAlignmentMode = .center
        pirateTalkLabel.position = CGPoint(x: 775, y: 145)
        pirate.addChild(pirateTalkLabel)
        
        flag.position = CGPoint(x: 0, y: 384)
        flag.zPosition = 3
        boat.addChild(flag)
        startFlagAnimation()
        
        cloud1.position = CGPoint(x: 1656, y: 1068)
        cloud1.zPosition = 50
        cloud1.name = "cloud"
        addChild(cloud1)
        cloud2.position = CGPoint(x: 1312, y: 812)
        cloud2.zPosition = 50
        cloud2.name = "cloud"
        addChild(cloud2)
        cloud3.position = CGPoint(x: 768, y: 1068)
        cloud3.zPosition = 50
        cloud3.name = "cloud"
        addChild(cloud3)
        
        let newCloud = SKAction.run {
            [weak self] in
            self?.spawnCloud()
        }
        let wait = SKAction.wait(forDuration: cloudGenerationInterval)
        let createClouds = [newCloud, wait]
        run(SKAction.repeatForever(SKAction.sequence(createClouds)), withKey: "animation")
        
        for i in 0...1 {
            let waveForeground = waveNode()
            waveForeground.anchorPoint = CGPoint.zero
            waveForeground.position = CGPoint(x: CGFloat(i) * waveForeground.size.width, y: 0)
            waveForeground.name = "wave"
            waveForeground.zPosition = 3
            addChild(waveForeground)
        }
        
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
        
        hudLabel.text = "What to do?"
        hudLabel.fontColor = #colorLiteral(red: 0.4470588235, green: 0.1607843137, blue: 0.4431372549, alpha: 1)
        hudLabel.fontSize = 64
        hudLabel.zPosition = 150
        hudLabel.horizontalAlignmentMode = .center
        hudLabel.verticalAlignmentMode = .top
        hudLabel.position = CGPoint(x: 512, y: 245)
        HUD.addChild(hudLabel)
        
        miniCannonBall.anchorPoint = CGPoint.zero
        miniCannonBall.position = CGPoint(x: 1244, y: 90)
        miniCannonBall.zPosition = 112
        miniCannonBall.name = "miniCannonBall"
        HUD.addChild(miniCannonBall)
        
        miniTreasureChest.anchorPoint = CGPoint.zero
        miniTreasureChest.position = CGPoint(x: 1414, y: 80)
        miniTreasureChest.zPosition = 112
        miniTreasureChest.name = "miniTreasureChest"
        HUD.addChild(miniTreasureChest)
        
        miniCannon.anchorPoint = CGPoint.zero
        miniCannon.position = CGPoint(x: 1634, y: 80)
        miniCannon.zPosition = 112
        miniCannon.name = "miniCannon"
        HUD.addChild(miniCannon)
        
        miniBeachBall.anchorPoint = CGPoint.zero
        miniBeachBall.position = CGPoint(x: 1824, y: 75)
        miniBeachBall.zPosition = 112
        miniBeachBall.name = "miniBeachBall"
        HUD.addChild(miniBeachBall)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        
        moveCloud(cloudspeed: cloudSpeed)
        moveWaves(waveSpeed: waveSpeed)
        
        if cloudSpeed > 100 {
            createIsland()
        }
        
        checkCollision()
        
        
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
            pirateTalkLabel.text = "Nothing to kick."
            return
        }
        if touchedNode.name == "pickUp" {
            hudLabel.text = "Pick Up"
            pirateTalkLabel.text = "I already have everything I want."
            return
        }
        if touchedNode.name == "drop" {
            hudLabel.text = "Drop"
            pirateTalkLabel.text = "All speed Ahead. Drop everything."
            dropThings = true
            return
        }
        if touchedNode.name == "force" {
            hudLabel.text = "Increase Force:"
            pirateTalkLabel.text = "We need speed, not force."
            return
        }
        if touchedNode.name == "miniCannonBall" {
            hudLabel.text = "What to do?"
            if dropThings == true {
                thing = "cannonBall"
                throwThingsAway(thing: thing)
            }
            return
        }
        if touchedNode.name == "miniBeachBall" {
            hudLabel.text = "What to do?"
            if dropThings == true {
                thing = "beachBall"
                throwThingsAway(thing: thing)
            }
            return
        }
        if touchedNode.name == "miniTreasureChest" {
            hudLabel.text = "What to do?"
            if dropThings == true {
                thing = "treasureChest"
                throwThingsAway(thing: thing)
            }
        }
        if touchedNode.name == "miniCannon" {
            hudLabel.text = "What to do?"
            if dropThings == true {
                thing = "cannon"
                throwThingsAway(thing: thing)
            }
            return
        }
    }
    
    func touchUp(atPoint pos: CGPoint) {
        //        let touchedNode = self.atPoint(pos)
        
    }
    
    func throwThingsAway(thing: String) {
        var throwThing = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 750, height: 375))
        if thing == "cannonBall" {
            throwThing = SKSpriteNode(imageNamed: "cannonBall")
            throwThing.size = CGSize(width: 50, height: 50)
            cloudSpeed += 1
            waveSpeed += 1
            pirateTalkLabel.text = "It helps a little."
        } else if thing == "beachBall" {
            throwThing = SKSpriteNode(imageNamed: "beachBall")
            throwThing.size = CGSize(width: 50, height: 50)
            cloudSpeed += 0.1
            waveSpeed += 0.1
            pirateTalkLabel.text = "Arrr, that won't help."
        } else if thing == "treasureChest" {
            throwThing = SKSpriteNode(imageNamed: "chestMini")
            cloudSpeed += 5
            waveSpeed += 5
            miniTreasureChest.removeFromParent()
            pirateTalkLabel.text = "Nooo! Not the treasure!"
        } else if thing == "cannon" {
            throwThing = SKSpriteNode(imageNamed: "cannonMini")
            cloudSpeed += 20
            waveSpeed += 20
            pirateTalkLabel.text = "Aye. That's it. Drop all the cannons"
            
        }
        
        throwThing.position = CGPoint(x: -200, y: -200)
        throwThing.zRotation = 90
        throwThing.zPosition = 5
        boat.addChild(throwThing)
        
        let actionMove = SKAction.moveBy(x: 0, y: -(size.width + throwThing.size.width), duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        throwThing.run(SKAction.sequence([actionMove, actionRemove]))
        
        
    }
    
    func createIsland() {
        var newPosition = island.position.x
        newPosition -= islandSpeed
        island.position.x = newPosition
    }
    
    func checkCollision() {
        if boat.frame.insetBy(dx: 400, dy: 0).intersects(island.frame) {
            cloudSpeed = 10
            waveSpeed = 0
            islandSpeed = 0
            var newPosition = self.pirate.position.x
            newPosition += 100
            pirate.position.x = newPosition
            if pirate.position.x > 3000 {
                pirate.removeFromParent()
            }
            if shipCrashed == false {
                crashAnimation()
            }
        }
    }
    
    func crashAnimation() {
        
        let wait = SKAction.wait(forDuration: 2)
        let moveCamera = SKAction.run {
            self.boat.removeAllActions()
            self.pirate.removeFromParent()
            self.pirateTalkLabel.removeFromParent()
            self.pirateLegs.position = CGPoint(x: 550, y: -100)
            self.pirateLegs.zPosition = 2
            self.pirateLegs.size = CGSize(width: self.pirateLegs.size.width * 0.5, height: self.pirateLegs.size.height * 0.5)
            self.island.addChild(self.pirateLegs)
            self.pirateLegs.addChild(self.pirateTalkLabel)
            self.pirateTalkLabel.position = CGPoint(x: 0, y: 100)
            self.pirateTalkLabel.text = "Help?"
        }
        let moveIsland = SKAction.run {
            self.island.run(SKAction.moveBy(x: -500, y: 0, duration: 1))
        }
        let moveBoat = SKAction.run {
            self.boat.run(SKAction.moveBy(x: -500, y: 0, duration: 1))
        }
        let group = [moveIsland, moveBoat]
        let crash = [wait, moveCamera, SKAction.group(group)]
        run(SKAction.sequence(crash))
        self.shipCrashed = true
        
        
    }
    
    func startFlagAnimation() {
        if flag.action(forKey: "animation") == nil {
            flag.run(SKAction.repeatForever(flagAnimation), withKey: "animation")
        }
    }
    
    func rockTheBoat(node: SKSpriteNode) {
        let rockRight = SKAction.rotate(byAngle: 0.087, duration: 1.5)
        let rockLeft = SKAction.rotate(byAngle: -0.087, duration: 1.5)
        let wait = SKAction.wait(forDuration: 0.5)
        let rockTheBoat = [rockRight, wait, rockLeft, wait]
        node.run(SKAction.repeatForever(SKAction.sequence(rockTheBoat)))
    }
    
    func spawnCloud() {
        let cloud = SKSpriteNode(imageNamed: "cloud")
        let backgroundRec = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        cloud.name = "cloud"
        cloud.position = CGPoint(x: backgroundRec.maxX + cloud.size.width/2, y: CGFloat.random( min: backgroundRec.maxY/2 + cloud.size.height/2, max: backgroundRec.maxY - cloud.size.height/2))
        cloud.zPosition = 50
        addChild(cloud)
        
    }
    
    func cloudAnimation(node: SKNode, cloudSpeed: TimeInterval) {
        let cloud = SKSpriteNode(imageNamed: "cloud")
        let actionMove = SKAction.moveBy(x: -(size.width + cloud.size.width), y: 0, duration: 10000)
        let actionRemove = SKAction.removeFromParent()
        node.run(SKAction.sequence([actionMove, actionRemove]))
    }
    
    func moveCloud(cloudspeed: CGFloat) {
        
        enumerateChildNodes(withName: "cloud") { (node, _) in
            if node.position.x > -200{
                var newPosition = node.position.x
                newPosition -= cloudspeed
                node.position.x = newPosition
            } else {
                node.run(SKAction.removeFromParent())
            }
        }
    }
    
    func waveNode() -> SKSpriteNode {
    
        let waveNode = SKSpriteNode()
        waveNode.anchorPoint = CGPoint.zero
        waveNode.name = "background"
        
        let wave1 = SKSpriteNode(imageNamed: "waveForeground")
        wave1.size = CGSize(width: wave1.size.width * 1.5, height: wave1.size.height)
        wave1.position = CGPoint(x: 1020 , y: 266)
        wave1.zPosition = 3
        waveNode.addChild(wave1)
        
        let wave2 = SKSpriteNode(imageNamed: "waveForeground")
        wave2.size = CGSize(width: wave2.size.width * 1.5, height: wave2.size.height)
        wave2.position =
            CGPoint(x: wave1.size.width + 1020, y: 266)
        wave2.zPosition = 3
        waveNode.addChild(wave2)
        
        waveNode.size = CGSize(width: wave1.size.width + wave2.size.width, height: 2)
        return waveNode
    }
    
    func moveWaves(waveSpeed: CGFloat) {
        enumerateChildNodes(withName: "wave") { node, _ in
            var newPosition = node.position.x
            newPosition -= waveSpeed
            node.position.x = newPosition
            
            let wave = node as! SKSpriteNode
            if wave.position.x + wave.size.width <
                self.cameraRect.origin.x {
                wave.position = CGPoint(
                    x: wave.position.x + wave.size.width*2,
                    y: wave.position.y)
            }
        }
        
    }
    
    func tide(node: SKSpriteNode, name: String) {
        
        let moveForwards = SKAction.moveBy(x: 25, y: 0, duration: 0.5)
        let moveBackwards = SKAction.moveBy(x: -25, y: 0, duration: 1.0)
        let waves = [moveForwards, moveBackwards]
        node.run(SKAction.repeatForever(SKAction.sequence(waves)))
        
    }
    
}
