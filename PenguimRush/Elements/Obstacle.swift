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
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.friction = 0
        self.physicsBody!.mass = 100
        self.physicsBody!.categoryBitMask = ColliderType.Obstacle.rawValue
        self.physicsBody!.contactTestBitMask = ColliderType.Penguin.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
