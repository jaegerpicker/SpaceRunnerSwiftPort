//
//  StarField.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/4/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import Foundation
import SpriteKit

class StarField : SKNode {
    override init() {
        super.init()
        var update :SKAction = SKAction.runBlock({[weak self] () -> Void in
            if arc4random_uniform(10) < 3 {
                self?.launchStar()
            }
        })
        var delay : SKAction = SKAction.waitForDuration(0.01)
        var updateLoop : SKAction = SKAction.sequence([delay, update])
        self.runAction(SKAction.repeatActionForever(updateLoop))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func launchStar()
    {
        var randX = UInt(arc4random_uniform(UInt32(UInt(self.scene!.size.width))))
        var maxY = UInt(self.scene!.size.height)
        var randomStart : CGPoint = CGPointMake(CGFloat(randX), CGFloat(maxY))
        var star : SKSpriteNode = SKSpriteNode(imageNamed: "shootingstar")
        star.position = randomStart
        star.size = CGSizeMake(2, 10)
        star.alpha = 0.1 + CGFloat(UInt(arc4random_uniform(10))) / 10.0
        self.addChild(star)
        var destY = 0 - self.scene!.size.height - star.size.height
        var duration : CGFloat = 0.1 + CGFloat(UInt(arc4random_uniform(10))) / 10.0
        var move : SKAction = SKAction.moveByX(0, y: destY, duration: NSTimeInterval(duration))
        var remove : SKAction = SKAction.removeFromParent()
        star.runAction(SKAction.sequence([move, remove]))
    }
}
