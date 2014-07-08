//
//  GameOverNode.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 7/7/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import SpriteKit

class GameOverNode : SKNode {
    init() {
        super.init()
        if self != nil {
            var label : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Heavy")
            label.fontSize = 32
            label.fontColor = SKColor.whiteColor()
            label.text = "Game Over"
            self.addChild(label)
            
            label.alpha = 0;
            label.xScale = 0.2;
            label.yScale = 0.2;
            
            var fadeIn : SKAction = SKAction.fadeAlphaTo(1, duration: 2)
            var scaleIn : SKAction = SKAction.scaleTo(1, duration: 2)
            var fadeAndScale : SKAction = SKAction.sequence([fadeIn, scaleIn])
            label.runAction(fadeAndScale)
            
            var instructions : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            instructions.fontSize = 14
            instructions.fontColor = SKColor.whiteColor()
            instructions.text = "Tap to try again."
            instructions.position = CGPointMake(0, -45);
            self.addChild(instructions)
            
            instructions.alpha = 0;
            var wait : SKAction = SKAction.waitForDuration(4)
            var appear : SKAction = SKAction.fadeAlphaTo(1, duration: 0.2)
            var popUp : SKAction = SKAction.scaleTo(1.1, duration: 0.1)
            var dropDown : SKAction = SKAction.scaleTo(1, duration: 0.1)
            var pauseAndAppear : SKAction = SKAction.sequence([wait, appear, popUp, dropDown])

            instructions.runAction(pauseAndAppear)
        }
    }
    
}
