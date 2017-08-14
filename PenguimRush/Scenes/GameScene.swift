//
//  GameScene.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var cam: SKCameraNode!
    
    private var penguim: Penguim!
    private var hud: Hud!
    
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
        
        let test = SKSpriteNode(imageNamed: "SizeTest")
        test.zPosition = 0
        self.addChild(test)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if penguim.position.y >= 0 {
            self.cam.position.y = penguim.position.y + (self.size.height*0.25)
            self.hud.position.y = self.cam.position.y
        }
        
    }
}
