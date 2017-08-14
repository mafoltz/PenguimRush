//
//  Environment.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Environment: SKSpriteNode {
    
    var obstacles = [Obstacle]()
    
    init(from json: [[[String: Any]]], index: Int) {
        let texture = SKTexture(imageNamed: "SizeTest")
        let color = UIColor.clear
        let size = texture.size()
        
        super.init(texture: texture, color: color, size: size)
        
        loadObstacles(from: json[index])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadObstacles(from json: [[String: Any]]) {
        for item in json {
            let type = ObstacleType(rawValue: item["type"] as! String)
            let x = item["x"] as! CGFloat
            let y = item["y"] as! CGFloat
            let z = item["z"] as! CGFloat
            
            let obstacle = Obstacle(withType: type!)
            obstacle.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0))
            obstacle.zPosition = z
            
            obstacles.append(obstacle)
            addChild(obstacle)
        }
    }
}
