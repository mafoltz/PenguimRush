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
    
    enum State {
        case Playing
        case GameOver
    }
    
    private var state = State.Playing
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.cam = SKCameraNode()
        self.addChild(self.cam)
        self.camera = self.cam
        
        self.backgroundColor = UIColor(red: 224/255, green: 236/255, blue: 239/255, alpha: 1.0)
        
        self.physicsWorld.contactDelegate = self
        
        self.hud = Hud(with: self.cam)
        self.addChild(self.hud)
        
        self.path = Path()
        self.addChild(self.path)
        
        self.setBlizzard()
        
        self.setUpControllerObservers()
        self.connectControllers()
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
        
        for player in self.players {
            player.removeAllActions()
            player.removeAllChildren()
            player.removeFromParent()
        }
        
        for conntroller in self.controllers {
            conntroller.removeAllActions()
            conntroller.removeAllChildren()
            conntroller.removeFromParent()
        }
        
        NotificationCenter.default.removeObserver(self)
        
        self.controllers = [Controller]()
        self.players = [Penguin]()
        
        for child in self.children {
            for childOfChild in child.children{
                childOfChild.removeAllActions()
                childOfChild.removeAllChildren()
            }
            child.removeAllActions()
            child.removeAllChildren()
        }
        
        self.blizzardParticle.removeAllActions()
        self.blizzardParticle.removeFromParent()
        
        self.removeAllActions()
        
        let scene = GameScene(size: self.size)
        view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        self.physicsWorld.contactDelegate = nil
        
        for player in self.players {
            player.state = .Crashed
        }
        
        self.hud.setAsGameOver()
        self.state = .GameOver
    }
    
    func controllerDisconnected(){
        self.isPaused = true
    }
    
    func connectControllers(){
        self.isPaused = false
        
        for (playerIndex, controller) in GCController.controllers().enumerated() {
            if ( controller.extendedGamepad != nil) {
                //Ignore
            } else if ( controller.gamepad != nil) {
                //Ignore
            } else if ( controller.microGamepad != nil) {
                controller.microGamepad?.valueChangedHandler = nil
                setUpMicroController(with: controller, and: playerIndex )
            }
        }
    }
    
    func setUpMicroController(with controller: GCController, and playerIndex: Int){
        let newController = Controller(with: controller, and: playerIndex)
        newController.delegate = self
        self.controllers.append(newController)
        self.addChild(newController)
        
        let penguin = Penguin()
        penguin.state = .Slide
        self.players.append(penguin)
        self.addChild(penguin)
    }
    
    func move(with xGravity: Double, and playerIndex: Int) {
        if self.state == .Playing {
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
    
    override func update(_ currentTime: TimeInterval) {
        if self.players.isEmpty {

        }
        else if self.state == .Playing{
            let moveCam = SKAction.move(to: CGPoint(x: 0, y: players.first!.position.y + (self.size.height*0.25) ), duration: 0.3)
            self.camera!.run(moveCam)
            self.blizzardParticle.position.y = self.cam.position.y + UIScreen.main.bounds.size.height / 2
            self.path.updatePosition(at: self.cam.position)
        }
        self.hud.position.y = self.cam.position.y
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.state == .GameOver {
            self.resetScene()
        }
    }
}
