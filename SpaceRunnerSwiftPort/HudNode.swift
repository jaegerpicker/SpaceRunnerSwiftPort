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
    
    init() {
        super.init()
        if self != nil {
            var scoreGroup : SKNode = SKNode()
            scoreGroup.name = "scoreGroup"
            
            var scoreTitle : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            scoreTitle.fontSize = 12
            scoreTitle.fontColor = SKColor.whiteColor()
            scoreTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            scoreTitle.text = "SCORE"
            scoreTitle.position = CGPointMake(0, 4);
            scoreGroup.addChild(scoreTitle)
            
            var scoreValue : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
            scoreValue.fontSize = 20
            scoreValue.fontColor = SKColor.whiteColor()
            scoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
            scoreValue.name = "scoreValue"
            scoreValue.text = "0"
            scoreValue.position = CGPointMake(0, -4)
            scoreGroup.addChild(scoreValue)
            self.addChild(scoreGroup)
            
            var elapsedGroup : SKNode = SKNode()
            elapsedGroup.name = "elapsedGroup"
            
            var elapsedTitle : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            elapsedTitle.fontSize = 12
            elapsedTitle.fontColor = SKColor.whiteColor()
            elapsedTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            elapsedTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            elapsedTitle.text = "TIME"
            elapsedTitle.position = CGPointMake(0, 4);
            elapsedGroup.addChild(elapsedTitle)
            
            var elapsedValue : SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
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
            
            var powerupGroup : SKNode = SKNode()
            powerupGroup.name = "powerupGroup"
            
            var powerupTitle : SKLabelNode = SKLabelNode(fontNamed:"AvenirNext-Bold")
            powerupTitle.fontSize = 14
            powerupTitle.fontColor = SKColor.redColor()
            powerupTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
            powerupTitle.text = "Power-up!"
            powerupTitle.position = CGPointMake(0, 4)
            powerupGroup.addChild(powerupTitle)
            
            var powerupValue : SKLabelNode = SKLabelNode(fontNamed:"AvenirNext-Bold")
            powerupValue.fontSize = 20
            powerupValue.fontColor = SKColor.redColor()
            powerupValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
            powerupValue.name = "powerupValue"
            powerupValue.text = "0s left"
            powerupValue.position = CGPointMake(0, -4)
            powerupGroup.addChild(powerupValue)
            
            self.addChild(powerupGroup)
            
            powerupGroup.alpha = 0
            
            var scaleUp : SKAction = SKAction.scaleTo(1.3, duration: 0.3)
            var scaleDown : SKAction = SKAction.scaleTo(1, duration: 0.3)
            var pulse : SKAction = SKAction.sequence([scaleUp, scaleDown])
            var pulseForever : SKAction = SKAction.repeatActionForever(pulse)
            powerupTitle.runAction(pulseForever)
        }
    }
    
    func layoutForScene() {
        assert(self.scene, "Cannot be called unless added to the scene")
        var sceneSize : CGSize = self.scene.size
        var groupSize : CGSize = CGSizeZero
        
        var scoreGroup : SKNode = self.childNodeWithName("scoreGroup")
        groupSize = scoreGroup.calculateAccumulatedFrame().size
        
        scoreGroup.position = CGPointMake(0 - sceneSize.width/2 + 20, sceneSize.height/2 - groupSize.height)
        
        var powerupGroup : SKNode = self.childNodeWithName("powerupGroup")
        
        groupSize = powerupGroup.calculateAccumulatedFrame().size
        powerupGroup.position = CGPointMake(0,sceneSize.height/2 - groupSize.height)
        
        var elapsedGroup : SKNode = self.childNodeWithName("elapsedGroup")
        groupSize = elapsedGroup.calculateAccumulatedFrame().size
        elapsedGroup.position = CGPointMake(sceneSize.width/2 - 20, sceneSize.height/2 - groupSize.height)
    }
    
    func addPoints(points : NSInteger) {
        self.score += points
        
        var scoreValue : SKLabelNode = self.childNodeWithName("scoreGroup/scoreValue") as SKLabelNode

        scoreValue.text = self.scoreFormatter.stringFromNumber(self.score)
        
        var scale : SKAction = SKAction.scaleTo(1.1, duration: 0.02)
        var shrink : SKAction = SKAction.scaleTo(1, duration: 0.07)
        var all : SKAction = SKAction.sequence([scale, shrink])
        scoreValue.runAction(all)
    }
    
    func startGame() {
        var startTime : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        var elapsedValue : SKLabelNode = self.childNodeWithName("elapsedGroup/elapsedValue") as SKLabelNode
        weak var weakself : HudNode? = self
        var update : SKAction = SKAction.runBlock({() -> Void in
            var now : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
            var elapsed : NSTimeInterval = now - startTime
            weakself!.elapsedTime = elapsed
            elapsedValue.text = weakself!.timeFormatter.stringFromNumber(elapsed)
        })
        var delay : SKAction = SKAction.waitForDuration(0.05)
        var updateAndDelay = SKAction.sequence([update, delay])
        var timer : SKAction = SKAction.repeatActionForever(updateAndDelay)
        self.runAction(timer, withKey:"elapsedGameTimer")
        
    }
    
    func endGame() {
        self.removeActionForKey("elapsedGameTimer")
        
        var powerupGroup : SKNode = self.childNodeWithName("powerupGroup")
        powerupGroup.removeActionForKey("showPowerupTimer")
        
        var fadeOut : SKAction = SKAction.fadeAlphaTo(0, duration: 0.3)
        powerupGroup.runAction(fadeOut)
    }
    
    func showPowerupTimer(time : NSTimeInterval) {
        var powerupGroup : SKNode = SKNode()
        powerupGroup.name = "powerupGroup"
        var powerupValue : SKLabelNode = SKLabelNode()
        powerupValue.name = "powerupValue"
        powerupGroup.addChild(powerupValue)
        
        powerupGroup.removeActionForKey("showPowerupTimer")
        
        var start : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        
        weak var weakSelf : HudNode? = self
        var block : SKAction = SKAction.runBlock({() -> Void in
            var elapsed : NSTimeInterval = NSDate.timeIntervalSinceReferenceDate() - start
            var left : NSTimeInterval = time - elapsed
            if left < 0 {
                left = 0;
            }
            powerupValue.text = "\(left)s left"
        })
        var blockPause : SKAction = SKAction.waitForDuration(0.05)
        var countdownSequence : SKAction = SKAction.sequence([block, blockPause])
        var countdown : SKAction = SKAction.repeatActionForever(countdownSequence)
        
        var fadeIn : SKAction = SKAction.fadeAlphaTo(1, duration: 0.1)
        var wait : SKAction = SKAction.waitForDuration(time)
        var fadeOut : SKAction = SKAction.fadeAlphaTo(9, duration: 1)
        var stopACtion : SKAction = SKAction.runBlock({() -> Void in
                powerupGroup.removeActionForKey("showPowerupTimer")
        })
        
        var visuals : SKAction = SKAction.sequence([fadeIn, wait, fadeOut, stopACtion])
        powerupGroup.runAction(visuals, withKey: "showPowerupTimer")
        
    }
    
}
