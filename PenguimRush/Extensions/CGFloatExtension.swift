//
//  CGFloatExtension.swift
//  nanoChallenge3
//
//  Created by Eduardo Fornari on 27/06/17.
//

import UIKit

extension CGFloat {
    static func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * (CGFloat.pi / 180)
    }
    
    static func radiansToDegrees(radians: CGFloat) -> CGFloat {
        return (radians*180) / CGFloat.pi
    }
}
