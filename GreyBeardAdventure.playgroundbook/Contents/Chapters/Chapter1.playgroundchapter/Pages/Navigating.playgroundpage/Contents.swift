
/*:
 ## The Island
 
 ### **Speeding up things.**
 
 Arr!! I am tired to kick stuff. I kicked too much heavy stuff. It is like as if the heavy things kicked me back. My foot hurts. I probably will need a pegleg after this.
 
 Anyway. I want to speed up our trip and the winds are not helping.
 
 Maybe if we make the ship lighter we can move faster.
 
 Let's drop overboard everything that is not usefull and see if it changes anything.
 
 [**Previous Page**](@previous)
 
 */
//#-hidden-code
//#-code-completion(everything, hide)

import PlaygroundSupport
import SpriteKit

// Create scene and view
let scene = BoatScene(size: CGSize(width: 2048, height: 1536))

let view = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))

scene.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
view.ignoresSiblingOrder = true
scene.scaleMode = .aspectFill
view.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view

//#-end-hidden-code
