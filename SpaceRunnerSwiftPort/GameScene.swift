//
//  GameScene.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/3/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var shipTouch = UITouch()
    var lastUpdateTime = NSTimeInterval()
    var lastShotFired = NSTimeInterval()
    var shipFireRate : CGFloat = 0.5
    
    func ca_nodeWithFile(named: NSString) -> SKEmitterNode {
        var baseName : NSString = named.stringByDeletingPathExtension
        var pathExtension : NSString = named.pathExtension
        if pathExtension.length == 0 {
            pathExtension = "sks"
        }
        var path : NSString = NSBundle.mainBundle().pathForResource(baseName, ofType: "sks")
        var node : SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as SKEmitterNode
        return node
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.blackColor()
        var starField : StarField = StarField()
        self.addChild(StarField() as SKNode)
        var name : NSString = "Spaceship.png"
        var ship : SKSpriteNode = SKSpriteNode(imageNamed: name)
        ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        ship.size = CGSizeMake(40, 40)
        ship.name = "ship"
        self.addChild(ship)
        var thurster : SKEmitterNode = ca_nodeWithFile("thrust")
        thurster.position = CGPointMake(0, -20)
        ship.addChild(thurster)
        
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.shipTouch = touches.anyObject() as UITouch
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }
        var timeDelta = currentTime - self.lastUpdateTime
        
        if self.shipTouch != nil {
            if currentTime - self.lastShotFired > self.shipFireRate {
                self.shoot()
                self.lastShotFired = currentTime
            }
            var ship : SKNode = self.childNodeWithName("ship")
            self.moveShipTowardPoint(self.shipTouch.locationInNode(self), byTimeDelta: timeDelta)
            //ship.position = self.shipTouch.locationInNode(self)
        }
        if arc4random_uniform(1000) <= 15 {
            self.dropthing()
        }
        self.checkCollisions()
        self.lastUpdateTime = currentTime
    }
    
    func moveShipTowardPoint(point: CGPoint, byTimeDelta: NSTimeInterval) {
        var shipSpeed:CGFloat = 130.0
        var ship : SKNode = self.childNodeWithName("ship")
        var distanceLeft = sqrt(pow(ship.position.x - point.x, 2) + pow(ship.position.y - point.y, 2))
        if distanceLeft > 4 {
            var distanceToTravel : CGFloat = byTimeDelta * shipSpeed
            var angle : CGFloat = atan2(point.y - ship.position.y, point.x - ship.position.x)
            var yoffset : CGFloat = distanceToTravel * sin(angle)
            var xoffset : CGFloat = distanceToTravel * cos(angle)
            ship.position = CGPointMake(ship.position.x + xoffset, ship.position.y + yoffset)
        }
        
    }
    
    func shoot() {
        var ship : SKNode = self.childNodeWithName("ship")
        var photon : SKSpriteNode = SKSpriteNode(imageNamed: "photon")
        photon.name = "photon"
        photon.position = ship.position
        self.addChild(photon)
        var fly : SKAction = SKAction.moveByX(0, y: self.size.height, duration: 0.5)
        var remove : SKAction = SKAction.removeFromParent()
        var fireAndRemove : SKAction = SKAction.sequence([fly, remove])
        photon.runAction(fireAndRemove)
    }
    
    func dropthing() {
        var dice : UInt32 = arc4random_uniform(100)
        if dice < 5 {
            self.dropPowerUp()
        } else if dice < 15 {
            self.dropEnemyShip()
        } else {
            self.dropAsteroid()
        }
    }
    
    func dropPowerUp()
    {
        var sideSize = 30.0
        var startX = CGFloat(arc4random_uniform(UInt32(self.size.width) - 60)) + CGFloat(30.0)
        var startY = self.size.height + sideSize
        var endY = 0 - sideSize
        var powerUp : SKSpriteNode = SKSpriteNode(imageNamed: "powerup")
        powerUp.size = CGSizeMake(sideSize, sideSize)
        powerUp.position = CGPointMake(startX, startY)
        powerUp.name = "powerup"
        self.addChild(powerUp)
        var move : SKAction = SKAction.moveTo(CGPointMake(startX, endY), duration: 6)
        var spin : SKAction = SKAction.rotateByAngle(-1, duration: 1)
        var remove : SKAction = SKAction.removeFromParent()
        var spinForever : SKAction = SKAction.repeatActionForever(spin)
        var travelAndRemove : SKAction = SKAction.sequence([move, remove])
        var all : SKAction = SKAction.group([spinForever, travelAndRemove])
        powerUp.runAction(all)
    }
    
    func dropEnemyShip() {
        var sideSize = 30.0
        var startX = CGFloat(arc4random_uniform(UInt32(self.size.width) - 40 ) ) + 20.0
        var startY = self.size.height + sideSize
        var enemy : SKSpriteNode = SKSpriteNode(imageNamed:"enemy")
        enemy.size = CGSizeMake(sideSize, sideSize)
        enemy.position = CGPointMake(startX, startY)
        enemy.name = "obstackle"
        self.addChild(enemy)
        var shipPath : CGPathRef = self.buildEnemyShipMovementPath()
        var followPath : SKAction = SKAction.followPath(shipPath, asOffset: true, orientToPath: true, duration: 7.0)
        var remove :SKAction = SKAction.removeFromParent()
        var all : SKAction = SKAction.sequence([followPath, remove])
    }
    
    func buildEnemyShipMovementPath() -> CGPathRef {
        var bezierPath : UIBezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0.5, -0.5))
        bezierPath.addCurveToPoint(CGPointMake(-2.5, -59.5),
            controlPoint1: CGPointMake(0.5, -0.5),
            controlPoint2: CGPointMake(4.55, -29.48))
        bezierPath.addCurveToPoint(CGPointMake(-27.5, -154.5),
            controlPoint1: CGPointMake(-9.55, -89.52),
            controlPoint2: CGPointMake(-43.32, -115.43))
        bezierPath.addCurveToPoint( CGPointMake(30.5, -243.5),
            controlPoint1: CGPointMake(-11.68, -193.57),
            controlPoint2: CGPointMake(17.28, -186.95))
        bezierPath.addCurveToPoint(CGPointMake(-52.5, -379.5),
            controlPoint1: CGPointMake(43.72, -300.05),
            controlPoint2: CGPointMake(-47.71, -335.76));
        bezierPath.addCurveToPoint( CGPointMake(54.5, -449.5),
            controlPoint1: CGPointMake(-57.29, -423.24),
            controlPoint2: CGPointMake(-8.14, -482.45))
        bezierPath.addCurveToPoint(CGPointMake(-5.5, -348.5),
            controlPoint1: CGPointMake(117.14, -416.55),
            controlPoint2: CGPointMake(52.25, -308.62));
        bezierPath.addCurveToPoint(CGPointMake(10.5, -494.5),
            controlPoint1: CGPointMake(-63.25, -388.38),
            controlPoint2: CGPointMake(-14.48, -457.43))
        bezierPath.addCurveToPoint(CGPointMake(0.5, -559.5),
            controlPoint1: CGPointMake(23.74, -514.16),
            controlPoint2: CGPointMake(6.93, -537.57))
        bezierPath.addCurveToPoint(CGPointMake(-2.5, -644.5),
            controlPoint1: CGPointMake(-5.2, -578.93),
            controlPoint2: CGPointMake(-2.5, -644.5));
        return bezierPath.CGPath
    }
    
    func dropAsteroid()
    {
        var ran = arc4random_uniform(30)
        var sideSize = 15.0 + CGFloat(ran)
        var maxX = UInt32(self.size.width)
        var quarterX = maxX / 4
        var startX = arc4random_uniform(maxX + (quarterX * 2)) - quarterX
        var startY = self.size.height + sideSize
        var endX = arc4random_uniform(maxX)
        var endY = 0 - sideSize
        var asteroid : SKSpriteNode = SKSpriteNode(imageNamed:"asteroid")
        asteroid.size = CGSizeMake(sideSize, sideSize)
        asteroid.position = CGPointMake(CGFloat(startX), startY)
        asteroid.name = "obstackle"
        self.addChild(asteroid)
        var move : SKAction = SKAction.moveTo(CGPointMake(CGFloat(endX), endY), duration: 3+CGFloat(arc4random_uniform(4)))
        var remove : SKAction = SKAction.removeFromParent()
        var travelAndRemove : SKAction = SKAction.sequence([move, remove])
        var spin : SKAction = SKAction.rotateByAngle(3.0, duration: CGFloat(arc4random_uniform(2)) + 1)
        var spinForever : SKAction = SKAction.repeatActionForever(spin)
        var all : SKAction = SKAction.group([spinForever, travelAndRemove])
        asteroid.runAction(all)
    }
    
    func checkCollisions() {
        var ship : SKNode = self.childNodeWithName("ship")
        self.enumerateChildNodesWithName("powerup", usingBlock: {(powerup: SKNode!, stop : CMutablePointer<ObjCBool>) -> Void in
            if ship.intersectsNode(powerup) {
                powerup.removeFromParent()
                self.shipFireRate = 0.1
                var powerdown : SKAction = SKAction.runBlock({() -> Void in
                        self.shipFireRate = 0.5
                    })
                var wait : SKAction = SKAction.waitForDuration(5.0)
                var waitAndPowerdown : SKAction = SKAction.sequence([wait, powerdown])
                ship.removeActionForKey("waitAndPowerdown")
                ship.runAction(waitAndPowerdown, withKey: "waitAndPowerdown")
            }
            })
        self.enumerateChildNodesWithName("obstackle", usingBlock: {(obstackle: SKNode!, stop : CMutablePointer<ObjCBool>) -> Void in
            if ship.intersectsNode(obstackle) {
                self.shipTouch.delete(self)
                ship.removeFromParent()
                obstackle.removeFromParent()
            }
            self.enumerateChildNodesWithName("photon", usingBlock: {(photon: SKNode!, stop: CMutablePointer<ObjCBool>) -> Void in
                if photon.intersectsNode(obstackle) {
                    photon.removeFromParent()
                    obstackle.removeFromParent()
                    //stop = true
                }
                })
            })
        
    }
}
