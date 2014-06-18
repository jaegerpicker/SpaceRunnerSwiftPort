//
//  SKNodeExtenstions.swift
//  SpaceRunnerSwiftPort
//
//  Created by Shawn Campbell on 6/6/14.
//  Copyright (c) 2014 Shawn Campbell. All rights reserved.
//
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        if let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as? GameScene
        {
            archiver.finishDecoding()
            return scene
        }
        
        return nil
    }
}