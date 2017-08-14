//
//  SKNodeUpdatableExtension.swift
//  Rocket
//
//  Created by Eduardo Fornari on 09/08/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import SpriteKit

extension Updatable where Self: SKNode {
    
    var updateRate: Double { return 1.0/60.0 /*FPS*/ }
    
    func updateScheduler(){
        let action = SKAction.run(self.update)
        let waitAction = SKAction.wait(forDuration: self.updateRate)
        let sequence = SKAction.sequence([action, waitAction])
        let repeating = SKAction.repeatForever(sequence)
        self.run(repeating)
    }
}
