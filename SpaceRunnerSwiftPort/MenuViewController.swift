//
//  MenuViewController.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/6/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//
import UIKit
import SpriteKit

class MenuController : UIViewController {
    var diff : UISegmentedControl = UISegmentedControl()
    var demoView : SKView = SKView()
    @IBOutlet var highScoreLabel : UILabel? = UILabel()
    @IBOutlet var difficulty : UISegmentedControl? = UISegmentedControl()
    @IBOutlet var playButton : UIButton? = UIButton()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var scoreFormatter : NSNumberFormatter = NSNumberFormatter()
        scoreFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var defaults : NSUserDefaults = NSUserDefaults()
        defaults.registerDefaults(["highscore":0])
        var score : NSNumber = defaults.valueForKey("highscore") as NSNumber
        var scoreString : NSString = "High Score: \(scoreFormatter.stringFromNumber(score))"
        self.highScoreLabel!.text = scoreString
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.demoView.frame = self.view.bounds
        if let scene : MenuScene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene {
            scene.backgroundColor = UIColor.blackColor()
            scene.scaleMode = SKSceneScaleMode.AspectFill
            var starField : StarField = StarField()
            scene.addChild(starField as SKNode)
            self.demoView.ignoresSiblingOrder = true
            self.demoView.presentScene(scene)
            self.view.insertSubview(self.demoView, atIndex: 0)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.demoView.removeFromSuperview()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "PlayGame" {
            var gc : GameViewController = segue.destinationViewController as GameViewController
            gc.easyMode = difficulty!.selected
        }
    }
}
