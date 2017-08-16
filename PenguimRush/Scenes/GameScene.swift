//
//  GameScene.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate, ControllerDelegate {
    func moveLeft(with playerIndex: Int) {
        if !self.players.isEmpty {
            self.players[playerIndex].moveLeft()
        }
    }
    
    func moveRight(with playerIndex: Int) {
        if !self.players.isEmpty {
            self.players[playerIndex].moveRight()
        }
    }
    
    func moveCenter(with playerIndex: Int) {
        if !self.players.isEmpty {
            self.players[playerIndex].moveCenter()
        }
    }
    
    
    private var cam: SKCameraNode!
    
    private var path: Path!
    private var hud: Hud!
    
    private var controllers = [Controller]()
    
    private var players = [Penguim]()
    
    private var blizzardParticle: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = UIColor(colorLiteralRed: 224/255, green: 236/255, blue: 239/255, alpha: 1.0)
        
        self.setUpControllerObservers()
        
        self.startScene()
    }
    
    func startScene() {
        
        self.physicsWorld.contactDelegate = self
        
        self.hud = Hud()
        self.addChild(self.hud)
        
        self.path = Path()
        self.addChild(self.path)
        
        self.cam = SKCameraNode()
        self.camera = self.cam
        
        self.setBlizzard()
    }
    
    func setBlizzard() {
        blizzardParticle = SKEmitterNode(fileNamed: "Snow.sks")
        blizzardParticle.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        blizzardParticle.particleSize = CGSize(width: 100, height: 100)
        blizzardParticle.zPosition = 10.0
        blizzardParticle.targetNode = self.scene
        
        addChild(blizzardParticle)
    }
    
    func resetScene() {
        
        self.hud.removeFromParent()
        
        self.path.removeFromParent()
        
        for player in self.players {
            player.removeFromParent()
        }
        
        self.players = [Penguim]()
        self.controllers = [Controller]()
        
        self.startScene()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        self.physicsWorld.contactDelegate = nil
        
        for player in self.players {
            player.state = .Crashed
        }
        
        contact.bodyA.pinned = true
        contact.bodyB.pinned = true
        
        let wait = SKAction.wait(forDuration: 2)
        let action = SKAction.run {
            
            self.resetScene()
            
        }
        
        self.run(SKAction.sequence([wait, action]))
        
    }
    
        func controllerDisconnected(){
            print("controllerDisconnected")
            self.isPaused = true
        }
    
        func connectControllers(){
            self.isPaused = false
    
            print("Controllers = \(GCController.controllers().count)")
            
            for controller in GCController.controllers() {
                if ( controller.extendedGamepad != nil) {
                    //Ignore
                } else if ( controller.gamepad != nil) {
                    //Ignore
                } else if ( controller.microGamepad != nil) {
                    controller.microGamepad?.valueChangedHandler = nil
                    setUpMicroController( controller )
                }
                
            }
    
        }
    
        func setUpMicroController(_ controller: GCController){
            self.controllers.append(Controller(with: controller))
        }
    
    override func update(_ currentTime: TimeInterval) {
        
        if self.players.isEmpty {
            if !GCController.controllers().isEmpty {
                let controller = Controller(with: GCController.controllers().first!)
                controller.delegate = self
                self.addChild(controller)
                self.controllers.append(controller)
                
                let penguim = Penguim()
                penguim.state = .Sliding
                self.addChild(penguim)
                self.players.append(penguim)
            }
        }
        else{
            self.cam.position.y = players.first!.position.y + (self.size.height*0.25)
            self.hud.position.y = self.cam.position.y
            self.blizzardParticle.position.y = self.cam.position.y
            self.path.updatePosition(at: self.cam.position)
        }
        
    }
}
