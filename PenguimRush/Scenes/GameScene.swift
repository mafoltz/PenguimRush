//
//  GameScene.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var cam: SKCameraNode!
    
    private var penguim: Penguim!
    private var path: Path!
    private var hud: Hud!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.white
        
        self.hud = Hud()
        self.addChild(self.hud)
        
        self.penguim = Penguim()
        self.penguim.state = .Sliding
        self.addChild(self.penguim)
        
        self.path = Path()
        self.addChild(self.path)
        
        self.cam = SKCameraNode()
        self.camera = self.cam
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.penguim.state = .Crashed
        
        
        let wait = SKAction.wait(forDuration: 2)
        let action = SKAction.run {
            let gameScene = GameScene(size: self.frame.size)
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene)
        }
        
        self.run(SKAction.sequence([wait, action]))
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
//        if penguim.position.y >= 0 {
            self.cam.position.y = penguim.position.y + (self.size.height*0.25)
            self.hud.position.y = self.cam.position.y
        
            let screenTopPosition = CGPoint(x: cam.position.x,
                                            y: cam.position.y - frame.size.height)
            path.updatePosition(at: screenTopPosition)
//        }
    }
}
