//
//  Obstacle.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Obstacle: SKSpriteNode {
    
    init(withType type: ObstacleType) {
        let texture = SKTexture(imageNamed: type.rawValue)
        let color = UIColor.clear
        let size = texture.size()
        
        super.init(texture: SKTexture(imageNamed: "Spaceship"), color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
