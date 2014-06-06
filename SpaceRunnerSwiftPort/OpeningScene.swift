//
//  OpeningScene.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/6/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import SpriteKit
import QuartzCore
import UIKit


class OpeningScene : SKScene {
    var callback: () -> () = { () -> Void in  }
    var slantedView : UIView = UIView()
    var textView : UITextView = UITextView()
    var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func didMoveToView(view: SKView!) {
        self.backgroundColor = UIColor.blackColor()
        var sf : StarField = StarField()
        self.addChild(sf as SKNode)
        var ship : SKSpriteNode = SKSpriteNode(imageNamed: "spaceship")
        self.addChild(ship)
        view.ignoresSiblingOrder = true
        self.slantedView.opaque = false
        self.slantedView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.slantedView)
        var transform : CATransform3D  = CATransform3DIdentity
        transform.m34 = -1.0/500.0
        transform = CATransform3DRotate(transform, (45.0 * M_PI / 180.0), 1.0, 0.0, 0.0)
        self.slantedView.layer.transform = transform
        self.textView.frame = CGRectInset(self.view.bounds, 30.0, 0.0)
        self.textView.opaque = false
        self.textView.backgroundColor = UIColor.clearColor()
        self.textView.textColor = UIColor.yellowColor()
        self.textView.font = UIFont(name: "AvenirNext-Medium", size: 20)
        self.textView.text = "A distress call comes in from thousands of light "
                             "years away. The colony is in jeopardy and needs "
                             "your help. Enemy ships and a meteor shower "
                             "threaten the work of the galaxy's greatest "
                             "scientific minds.\n\n"
                             "Will you be able to reach "
                             "them in time to save the research?\n\n"
                             "Or has the galaxy lost it's only hope?"
        self.textView.userInteractionEnabled = false
        self.textView.center = CGPointMake(self.size.width/2 + 15.0, self.size.height + (self.size.height/2))
        self.slantedView.addSubview(self.textView)
        var gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradient.startPoint = CGPointMake(0.5, 0.0)
        gradient.endPoint = CGPointMake(0.5, 0.20)
        self.slantedView.layer.mask = gradient
        UIView.animateWithDuration(20, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,
            animations: {() -> Void in
                self.textView.center = CGPointMake(self.size.width/2.0, 0.0 - (self.size.height/2.0))
            },
            completion: {(b: Bool) -> Void in
                if b {
                    self.endScene()
                }
            })
        var endSceneSelector : Selector = "endScene:"
        self.tapGesture = UITapGestureRecognizer(target: self, action: endSceneSelector)
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    override func willMoveFromView(view: SKView!) {
        self.view.removeGestureRecognizer(self.tapGesture)
        self.slantedView.removeFromSuperview()
    }
    
    func endScene() {
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            self.textView.alpha = 0.0
            }, completion: {(b: Bool) -> Void in
                self.textView.layer.removeAllAnimations()
                assert(self.callback != nil)
                self.callback()
            })
        
    }
}
