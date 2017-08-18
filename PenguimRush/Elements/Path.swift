//
//  Path.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 15/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Path: SKNode {
    
    enum State {
        case Beginner
        case Random
    }
    
    private var availableEnvironments = [Environment]()
    private var environments = [Environment]()
    private var lastObstacleYPosition: CGFloat!
    private var json: [[[String : Any]]]!
    
    override init() {
        super.init()
        
        self.json = JsonReader.openJson(named: "Environments")!
        
        updateEnvironment(state: .Beginner)
        updateEnvironment(state: .Beginner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPosition(forEnvironment environment: Environment){
        if self.lastObstacleYPosition == nil {
            self.lastObstacleYPosition = -environment.size.height
        }
        
        environment.position.y = lastObstacleYPosition
        self.lastObstacleYPosition! += environment.size.height
    }
    
    private func updateEnvironment(state: State) {
        let index: Int!
        
        if state == .Random {
            index = Int(arc4random_uniform(UInt32(json.count - 1))) + 1
        }
        else {
            index = 0
        }
        
        var newEnvironment = self.availableEnvironments.filter({ (environment) -> Bool in
            return environment.index == index
        }).first
        
        if newEnvironment == nil {
            let environmentData = self.json[index]
            newEnvironment = Environment(from: environmentData, index: index)
            self.setPosition(forEnvironment: newEnvironment!)
            self.addChild(newEnvironment!)
            self.environments.append(newEnvironment!)
        }
        else{
            let obstacleIndex = availableEnvironments.index(of: newEnvironment!)!
            
            self.setPosition(forEnvironment: newEnvironment!)
            self.environments.append(availableEnvironments.remove(at: obstacleIndex))
        }
    }
    
    func updatePosition(at currentPosition: CGPoint) {
        if currentPosition.y - environments.first!.position.y > (environments.first!.size.height) {
            self.availableEnvironments.append(environments.removeFirst())
            self.updateEnvironment(state: .Random)
        }
    }
}
