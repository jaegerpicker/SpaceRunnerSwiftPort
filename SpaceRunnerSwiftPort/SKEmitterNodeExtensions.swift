//
//  SKEmitterNodeExtensions.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/4/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import SpriteKit

extension SKEmitterNode {
    func ca_nodeWithFile(named: NSString) -> SKEmitterNode {
        let baseName : NSString = named.stringByDeletingPathExtension
        var pathExtension : NSString = named.pathExtension
        if pathExtension.length == 0 {
            pathExtension = "sks"
        }
        let path : NSString = NSBundle.mainBundle().pathForResource(baseName as String, ofType: "sks")!
        let node : SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(path as String) as! SKEmitterNode
        return node
    }
    
    func ca_dieOutInDuration(duration: NSTimeInterval) {
        let firstWait : SKAction = SKAction.waitForDuration(duration)
        weak var weakSelf : SKEmitterNode? = self
        let stop : SKAction = SKAction.runBlock({() -> Void in
            weakSelf!.particleBirthRate = 0
        })
        let secondWait : SKAction = SKAction.waitForDuration(NSTimeInterval(weakSelf!.particleLifetime))
        let remove : SKAction = SKAction.removeFromParent()
        let dieOut : SKAction = SKAction.sequence([firstWait, stop, secondWait, remove])
        weakSelf!.runAction(dieOut)
    }
}
