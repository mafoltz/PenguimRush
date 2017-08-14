//
//  Scaleable.swift
//  Rocket
//
//  Created by Eduardo Fornari on 08/08/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import SpriteKit

protocol Scaleable: class {
    
    var size: CGSize { get set }
    
    func updateScale(forDeviceWidthPercentage percent: CGFloat)
    
    func updateScale(forDeviceHeightPercentage percent: CGFloat)
    
}
