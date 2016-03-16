//
//  MenuScene.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/6/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//
import SpriteKit

class MenuScene : SKScene {
    
    override func didMoveToView(view: SKView!) {
        self.backgroundColor = UIColor.blackColor()
        let sf : StarField = StarField()
        self.addChild(sf as SKNode)
        let ship : SKSpriteNode = SKSpriteNode(imageNamed: "spaceship")
        self.addChild(ship)
        view.ignoresSiblingOrder = true

    }
    
}
