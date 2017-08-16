//
//  Penguim.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameController

class Penguim: SKNode, Updatable, Scaleable {
    
    var size: CGSize = CGSize(width: 0, height: 0)
    
    public enum State {
        case Stopped
        case Sliding
        case Crashed
    }
    
    private let actionTime = TimeInterval(0.15)
    
    public var state = State.Stopped
    
    private var velocity: CGFloat!
    
    override init() {
        super.init()
        
        //Rocket
        
        let penguin = SKSpriteNode(imageNamed: "Spaceship")
        
        self.size = penguin.size
        
        self.addChild(penguin)
        
        self.zPosition = 100
        
        self.physicsBody = SKPhysicsBody(texture: penguin.texture!, size: penguin.size)
        
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.friction = 0
        self.physicsBody!.categoryBitMask = ColliderType.Penguin.rawValue
        self.physicsBody!.contactTestBitMask = ColliderType.Obstacle.rawValue
        
        self.updateScale(forDeviceHeightPercentage: 0.185546875)
        
        self.position.y = -(UIScreen.main.bounds.height/2) + (self.size.height/2) + UIScreen.main.bounds.width*0.0673828125
        
        self.velocity = self.size.height
        
        self.updateScheduler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(){
        
        if self.state == .Sliding {
            self.physicsBody?.velocity = CGVector(dx: (self.physicsBody?.velocity.dx)!, dy: self.velocity)
            
            let screenWidth = UIScreen.main.bounds.width
            
            if self.position.x > (screenWidth/2) {
                self.position.x = (screenWidth/2)
            }
            else if self.position.x < -(screenWidth/2) {
                self.position.x = -(screenWidth/2)
            }
        }
        else if self.state == .Crashed {
            
        }
    }
    
    public func moveLeft(){
        self.physicsBody!.applyImpulse(CGVector(dx: -self.size.width*0.1, dy: 0))
        if self.action(forKey: "move") == nil {
            let rotateAction = SKAction.rotate(toAngle: 0.0872665, duration: actionTime)
            self.run(rotateAction, withKey: "move")
        }
    }
    
    public func moveRight(){
        self.physicsBody!.applyImpulse(CGVector(dx: self.size.width*0.1, dy: 0))
        if self.action(forKey: "move") == nil {
            let rotateAction = SKAction.rotate(toAngle: -0.0872665, duration: actionTime)
            self.run(rotateAction, withKey: "move")
        }
    }
    
    public func moveCenter(){
//        self.physicsBody!.velocity.dx = 0
        if self.action(forKey: "move") == nil && self.zPosition != 0 {
            let rotateAction = SKAction.rotate(toAngle: 0, duration: actionTime)
            self.run(rotateAction, withKey: "move")
        }
    }
    
}
