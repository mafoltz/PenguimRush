//
//  Updatable.swift
//  Rocket
//
//  Created by Eduardo Fornari on 09/08/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import SpriteKit

protocol Updatable: class {
    
    var updateRate: Double { get }
    
    func updateScheduler()
    
    func update()
    
}
