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
    
    private var cam: SKCameraNode!
    private var path: Path!
    private var hud: Hud!
    private var controllers = [Controller]()
    private var players = [Penguin]()
    private var blizzardParticle: SKEmitterNode!
    
    private var started = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = UIColor(red: 224/255, green: 236/255, blue: 239/255, alpha: 1.0)
        
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
        self.addChild(self.cam)
        self.camera = self.cam
        
        self.setBlizzard()
    }
    
    func setBlizzard() {
        blizzardParticle = SKEmitterNode(fileNamed: "Snow.sks")
        blizzardParticle.particlePositionRange = CGVector(dx: size.width, dy: size.height)
        blizzardParticle.particleSize = CGSize(width: 100, height: 100)
        blizzardParticle.particleZPosition = 20.0
        blizzardParticle.targetNode = self.scene
        addChild(blizzardParticle)
    }
    
    func resetScene() {
        for child in self.children {
            for childOfChild in child.children{
                childOfChild.removeAllActions()
                childOfChild.removeAllChildren()
            }
            child.removeAllActions()
            child.removeAllChildren()
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        
        self.players = [Penguin]()
        self.controllers = [Controller]()
        self.blizzardParticle = SKEmitterNode()
        
        let scene = GameScene(size: self.size)
        view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.physicsWorld.contactDelegate = nil
        
        for player in self.players {
            player.state = .Crashed
        }
        
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
    
    func move(with xGravity: Double, and playerIndex: Int) {
        
        if !started {
            if abs(xGravity) > 0.5 {
                self.start()
            }
        }
        else {
            if abs(xGravity) > 0.15 {
                if xGravity > 0 {
                    self.players[playerIndex].moveRight()
                }
                else {
                    self.players[playerIndex].moveLeft()
                }
            }
            else {
                self.players[playerIndex].moveCenter()
            }
        }
    }
    
    func start(){
        self.started = true
        for player in self.players {
            player.state = .Slide
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.players.isEmpty {
            if !GCController.controllers().isEmpty {
                let controller = Controller(with: GCController.controllers().first!)
                controller.delegate = self
                self.addChild(controller)
                self.controllers.append(controller)
                
                let penguim = Penguin()
                self.addChild(penguim)
                self.players.append(penguim)
            }
        }
        else if started{
            let moveCam = SKAction.move(to: CGPoint(x: 0, y: players.first!.position.y + (self.size.height*0.25) ), duration: 0.3)
            self.camera!.run(moveCam)
            self.hud.position.y = self.cam.position.y
            self.blizzardParticle.position.y = self.cam.position.y + UIScreen.main.bounds.size.height / 2
            self.path.updatePosition(at: self.cam.position)
        }
    }
}
