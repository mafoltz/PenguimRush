//
//  Path.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 15/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Path: SKNode {
    
    private var availableEnvironments = [Environment]()
    private var environment1: Environment!
    private var environment2: Environment!
    
    override init() {
        super.init()
        
        let json = JsonReader.openJson(named: "Environments")!
        
        for (index, environmentData) in json.enumerated() {
            let environment = Environment(from: environmentData, index: index)
            availableEnvironments.append(environment)
        }
        
        environment1 = getRandomEnvironment()
        addChild(environment1)
        
        environment2 = getRandomEnvironment()
        addChild(environment2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getRandomEnvironment() -> Environment {
        let index = Int(arc4random_uniform(UInt32(availableEnvironments.count)))
        return availableEnvironments.remove(at: index)
    }
    
    func updatePosition(at currentPosition: CGPoint) {
        if currentPosition.y > environment1.position.y {
            let y = environment1.position.y + environment1.size.height
            
            availableEnvironments.append(environment1)
            environment1 = getRandomEnvironment()
            environment1.position.y = y
        }
        
        if currentPosition.y > environment2.position.y + environment2.size.height {
            let y = environment2.position.y + environment2.size.height
            
            availableEnvironments.append(environment2)
            environment2 = getRandomEnvironment()
            environment2.position.y = y
        }
    }
}
