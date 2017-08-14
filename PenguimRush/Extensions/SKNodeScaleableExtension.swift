//
//  SKNodeExtension.swift
//  Rocket
//
//  Created by Eduardo Fornari on 08/08/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import SpriteKit

extension Scaleable where Self: SKNode {
    
    func updateScale(forDeviceWidthPercentage percent: CGFloat) {
        self.xScale = 1
        self.yScale = 1
        
        let scale = (UIScreen.main.bounds.width*percent)/self.size.width
        
        self.xScale = scale
        self.yScale = scale
        
        self.size.height *= scale
        self.size.width *= scale
    }
    
    func updateScale(forDeviceHeightPercentage percent: CGFloat) {
        self.xScale = 1
        self.yScale = 1

        let scale = (UIScreen.main.bounds.height*percent)/self.size.height

        self.xScale = scale
        self.yScale = scale

        self.size.height *= scale
        self.size.width *= scale
    }
    
}
