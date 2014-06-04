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
        var baseName : NSString = named.stringByDeletingPathExtension
        var pathExtension : NSString = named.pathExtension
        if pathExtension.length == 0 {
            pathExtension = "sks"
        }
        var path : NSString = NSBundle.mainBundle().pathForResource(baseName, ofType: "sks")
        var node : SKEmitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as SKEmitterNode
        return node
    }
}
