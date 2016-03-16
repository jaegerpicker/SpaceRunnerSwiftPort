//
//  GameOverNode.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 7/7/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import SpriteKit

class GameOverNode : SKNode {
    override init() {
        super.init()
            let label : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Heavy")
            label.fontSize = 32
            label.fontColor = SKColor.whiteColor()
            label.text = "Game Over"
            self.addChild(label)
            
            label.alpha = 0;
            label.xScale = 0.2;
            label.yScale = 0.2;
            
            let fadeIn : SKAction = SKAction.fadeAlphaTo(1, duration: 2)
            let scaleIn : SKAction = SKAction.scaleTo(1, duration: 2)
            let fadeAndScale : SKAction = SKAction.sequence([fadeIn, scaleIn])
            label.runAction(fadeAndScale)
            
            let instructions : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            instructions.fontSize = 14
            instructions.fontColor = SKColor.whiteColor()
            instructions.text = "Tap to try again."
            instructions.position = CGPointMake(0, -45);
            self.addChild(instructions)
            
            instructions.alpha = 0;
            let wait : SKAction = SKAction.waitForDuration(4)
            let appear : SKAction = SKAction.fadeAlphaTo(1, duration: 0.2)
            let popUp : SKAction = SKAction.scaleTo(1.1, duration: 0.1)
            let dropDown : SKAction = SKAction.scaleTo(1, duration: 0.1)
            let pauseAndAppear : SKAction = SKAction.sequence([wait, appear, popUp, dropDown])

            instructions.runAction(pauseAndAppear)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
}
