//
//  HudNode.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 7/7/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import SpriteKit

class HudNode : SKNode {
    var elapsedTime : NSTimeInterval = 0.0
    var score : NSInteger = 0
    var scoreFormatter : NSNumberFormatter = NSNumberFormatter()
    var timeFormatter : NSNumberFormatter = NSNumberFormatter()
    
    override init() {
        super.init()

            let scoreGroup : SKNode = SKNode()
            scoreGroup.name = "scoreGroup"
            
            let scoreTitle : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            scoreTitle.fontSize = 12
            scoreTitle.fontColor = SKColor.whiteColor()
            scoreTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            scoreTitle.text = "SCORE"
            scoreTitle.position = CGPointMake(0, 4);
            scoreGroup.addChild(scoreTitle)
            
            let scoreValue : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
            scoreValue.fontSize = 20
            scoreValue.fontColor = SKColor.whiteColor()
            scoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
            scoreValue.name = "scoreValue"
            scoreValue.text = "0"
            scoreValue.position = CGPointMake(0, -4)
            scoreGroup.addChild(scoreValue)
            self.addChild(scoreGroup)
            
            let elapsedGroup : SKNode = SKNode()
            elapsedGroup.name = "elapsedGroup"
            
            let elapsedTitle : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            elapsedTitle.fontSize = 12
            elapsedTitle.fontColor = SKColor.whiteColor()
            elapsedTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            elapsedTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            elapsedTitle.text = "TIME"
            elapsedTitle.position = CGPointMake(0, 4);
            elapsedGroup.addChild(elapsedTitle)
            
            let elapsedValue : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
            elapsedValue.fontSize = 20
            elapsedValue.fontColor = SKColor.whiteColor()
            elapsedValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            elapsedValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
            elapsedValue.name = "elapsedValue"
            elapsedValue.text = "0.0s"
            elapsedValue.position = CGPointMake(0, -4)
            elapsedGroup.addChild(elapsedValue)
            
            self.addChild(elapsedGroup)
            
            self.scoreFormatter = NSNumberFormatter()
            self.scoreFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            
            self.timeFormatter = NSNumberFormatter()
            self.timeFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            self.timeFormatter.minimumFractionDigits = 1
            self.timeFormatter.maximumFractionDigits = 1
            
            let powerupGroup : SKNode = SKNode()
            powerupGroup.name = "powerupGroup"
            
            let powerupTitle : SKLabelNode = SKLabelNode(fontNamed:"AvenirNext-Bold")
            powerupTitle.fontSize = 14
            powerupTitle.fontColor = SKColor.redColor()
            powerupTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            powerupTitle.text = "Power-up!"
            powerupTitle.position = CGPointMake(0, 4)
            powerupGroup.addChild(powerupTitle)
            
            let powerupValue : SKLabelNode = SKLabelNode(fontNamed:"AvenirNext-Bold")
            powerupValue.fontSize = 20
            powerupValue.fontColor = SKColor.redColor()
            powerupValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
            powerupValue.name = "powerupValue"
            powerupValue.text = "0s left"
            powerupValue.position = CGPointMake(0, -4)
            powerupGroup.addChild(powerupValue)
            
            self.addChild(powerupGroup)
            
            powerupGroup.alpha = 0
            
            let scaleUp : SKAction = SKAction.scaleTo(1.3, duration: 0.3)
            let scaleDown : SKAction = SKAction.scaleTo(1, duration: 0.3)
            let pulse : SKAction = SKAction.sequence([scaleUp, scaleDown])
            let pulseForever : SKAction = SKAction.repeatActionForever(pulse)
            powerupTitle.runAction(pulseForever)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutForScene() {
        //assert(self.scene, "Cannot be called unless added to the scene")
        let sceneSize : CGSize = self.scene!.size
        var groupSize : CGSize = CGSizeZero
        
        let scoreGroup : SKNode = self.childNodeWithName("scoreGroup")!
        groupSize = scoreGroup.calculateAccumulatedFrame().size
        
        scoreGroup.position = CGPointMake(0 - sceneSize.width/2 + 20, sceneSize.height/2 - groupSize.height)
        
        let powerupGroup : SKNode = self.childNodeWithName("powerupGroup")!
        
        groupSize = powerupGroup.calculateAccumulatedFrame().size
        powerupGroup.position = CGPointMake(0,sceneSize.height/2 - groupSize.height)
        
        let elapsedGroup : SKNode = self.childNodeWithName("elapsedGroup")!
        groupSize = elapsedGroup.calculateAccumulatedFrame().size
        elapsedGroup.position = CGPointMake(sceneSize.width/2 - 20, sceneSize.height/2 - groupSize.height)
    }
    
    func addPoints(points : NSInteger) {
        self.score += points
        
        let scoreValue : SKLabelNode = self.childNodeWithName("scoreGroup/scoreValue") as! SKLabelNode

        scoreValue.text = self.scoreFormatter.stringFromNumber(self.score)!
        
        let scale : SKAction = SKAction.scaleTo(1.1, duration: 0.02)
        let shrink : SKAction = SKAction.scaleTo(1, duration: 0.07)
        let all : SKAction = SKAction.sequence([scale, shrink])
        scoreValue.runAction(all)
    }
    
    func startGame() {
        let startTime : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        let elapsedValue : SKLabelNode = self.childNodeWithName("elapsedGroup/elapsedValue") as! SKLabelNode
        weak var weakself : HudNode? = self
        let update : SKAction = SKAction.runBlock({() -> Void in
            let now : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
            let elapsed : NSTimeInterval = now - startTime
            weakself!.elapsedTime = elapsed
            elapsedValue.text = weakself!.timeFormatter.stringFromNumber(elapsed)!
        })
        let delay : SKAction = SKAction.waitForDuration(0.05)
        let updateAndDelay = SKAction.sequence([update, delay])
        let timer : SKAction = SKAction.repeatActionForever(updateAndDelay)
        self.runAction(timer, withKey:"elapsedGameTimer")
        
    }
    
    func endGame() {
        self.removeActionForKey("elapsedGameTimer")
        
        let powerupGroup : SKNode = self.childNodeWithName("powerupGroup")!
        powerupGroup.removeActionForKey("showPowerupTimer")
        
        let fadeOut : SKAction = SKAction.fadeAlphaTo(0, duration: 0.3)
        powerupGroup.runAction(fadeOut)
    }
    
    func showPowerupTimer(time : NSTimeInterval) {
        let powerupGroup : SKNode = SKNode()
        powerupGroup.name = "powerupGroup"
        let powerupValue : SKLabelNode = SKLabelNode()
        powerupValue.name = "powerupValue"
        powerupGroup.addChild(powerupValue)
        
        powerupGroup.removeActionForKey("showPowerupTimer")
        
        let start : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        
        //weak var weakSelf : HudNode? = self
        let block : SKAction = SKAction.runBlock({() -> Void in
            let elapsed : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate() - start
            var left : NSTimeInterval = time - elapsed
            if left < 0 {
                left = 0;
            }
            powerupValue.text = "\(left)s left"
        })
        let blockPause : SKAction = SKAction.waitForDuration(0.05)
        let countdownSequence : SKAction = SKAction.sequence([block, blockPause])
        let countdown : SKAction = SKAction.repeatActionForever(countdownSequence)
        
        let fadeIn : SKAction = SKAction.fadeAlphaTo(1, duration: 0.1)
        let wait : SKAction = SKAction.waitForDuration(time)
        let fadeOut : SKAction = SKAction.fadeAlphaTo(9, duration: 1)
        let stopACtion : SKAction = SKAction.runBlock({() -> Void in
                powerupGroup.removeActionForKey("showPowerupTimer")
        })
        
        let visuals : SKAction = SKAction.sequence([fadeIn, wait, fadeOut, stopACtion])
        powerupGroup.runAction(visuals, withKey: "showPowerupTimer")
        
    }
    
}
