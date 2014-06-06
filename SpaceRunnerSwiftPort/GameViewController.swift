//
//  GameViewController.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/3/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {
    var easyMode : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if let openingScene : OpeningScene = OpeningScene.unarchiveFromFile("OpeningScene") as? OpeningScene {
            openingScene.scaleMode = .AspectFill
            var transition : SKTransition = SKTransition.fadeWithDuration(1)
            let skView : SKView = self.view as SKView
            skView.presentScene(openingScene, transition: transition)
        
            openingScene.callback = {
                if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                    // Configure the view.
                    //let skView = self.view as SKView
                    skView.showsFPS = true
                    skView.showsNodeCount = true
            
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
            
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    scene.easyMode = self.easyMode
                    skView.presentScene(scene)
                }
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
