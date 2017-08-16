//
//  Environment.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Environment: SKNode, Scaleable {
    
    private var scenary = [SKSpriteNode]()
    private var obstacles = [Obstacle]()
    
    public var index: Int!
    var size: CGSize = CGSize(width: 0, height: 0)
    
    init(from json: [[String: Any]], index: Int) {
        super.init()
        
        self.index = index
        self.size = UIScreen.main.bounds.size
        
        loadScenary()
        loadObstacles(from: json)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadScenary() {
        let leftScenary = SKSpriteNode(imageNamed: "ScenaryLeft")
        leftScenary.position.x = (leftScenary.size.width - size.width) / 2
        scenary.append(leftScenary)
        addChild(leftScenary)
        
        let rightScenary = SKSpriteNode(imageNamed: "ScenaryRight")
        rightScenary.position.x = (size.width - rightScenary.size.width) / 2
        scenary.append(rightScenary)
        addChild(rightScenary)
    }
    
    func loadObstacles(from json: [[String: Any]]) {
        for item in json {
            let type = ObstacleType(rawValue: item["type"] as! String)
            let x = item["x"] as! CGFloat
            let y = item["y"] as! CGFloat
            let z = item["z"] as! CGFloat
            
            let obstacle = Obstacle(withType: type!)
            obstacle.position.x = x
            obstacle.position.y = y
            obstacle.zPosition = z
            
            obstacles.append(obstacle)
            addChild(obstacle)
        }
    }
}
