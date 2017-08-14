//
//  GameScene.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private let json = JsonReader.openJson(named: "Environments")
    
    private var cam: SKCameraNode!
    
    private var penguim: Penguim!
    private var hud: Hud!
    private var environment1: Environment!
    private var environment2: Environment!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = UIColor.white
        
        self.hud = Hud()
        self.addChild(self.hud)
        
        self.penguim = Penguim()
        self.addChild(self.penguim)
        
        self.cam = SKCameraNode()
        self.camera = self.cam
        
        self.environment1 = Environment(from: json!, index: 1)
        self.addChild(self.environment1)
        
        self.environment2 = Environment(from: json!, index: 1)
        self.addChild(self.environment2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if penguim.position.y >= 0 {
            self.cam.position.y = penguim.position.y + (self.size.height*0.25)
            self.hud.position.y = self.cam.position.y
        }
        
        if self.cam.position.y > self.environment1.position.y {
            self.environment1.position.y = self.environment1.position.y + self.environment1.size.height
        }
        
        if self.cam.position.y > self.environment2.position.y + self.environment2.size.height {
            self.environment2.position.y = self.environment2.position.y + self.environment2.size.height
        }
    }
}
