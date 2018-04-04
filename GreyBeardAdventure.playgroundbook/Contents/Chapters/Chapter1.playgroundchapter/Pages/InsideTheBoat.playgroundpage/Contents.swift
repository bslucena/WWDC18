/*:
 # The adventures of GreyBeard, the pirate.
 
 ## The journey.
 
 ### **Nothing to do**
 
 Ahoy mateys, I am GreyBeard and I am traveling to hide my treasure.
 I found an island which no one knows. It is a beautiful island full of monkeys. I call it Banana Island TM. You get it? Because monkeys love bananas.
 But the journey is too long and right now I am a little bored.
 
 What do you say about us playing some games. Maybe kick some things.
 
 I have been playing with a few of these itens, and it looks that I have to kick with more force the heavier itens to make it move. Make sense right? Looks like the things want to do what they are already doing before someone comes and make them do something else. So if it is resting it is harder to make a heavier object move than a lighter one. And if it is moving it is harder to stop a heavier object than a lighter one.
 
 But don't take my word about it. Let's find some objects to kick. Pick up some itens in the screen and let's kick some buts.
 
 [**Next Page**](@next)
 
 */
//#-hidden-code
//#-code-completion(everything, hide)

import PlaygroundSupport
import SpriteKit

// Create the scene and the view
let scene = GameScene(size: CGSize(width: 2048, height: 1536))

let view = SKView(frame: CGRect(x: 0, y: 0, width: 640, height: 380))

view.ignoresSiblingOrder = true
scene.scaleMode = .aspectFill
view.presentScene(scene)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view

//#-end-hidden-code
