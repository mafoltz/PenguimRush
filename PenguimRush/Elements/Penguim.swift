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
    
    public enum State {
        case Stopped
        case Slide
        case Sliding
        case Crashed
    }
    
    var size: CGSize = CGSize(width: 0, height: 0)
    private let actionTime = TimeInterval(0.15)
    public var state = State.Stopped
    private var velocity: CGFloat!
    private var impulseVelocity: CGFloat!
    private var sprite: SKSpriteNode!
    private var trailParticle: SKEmitterNode!
    private var previousTrailParticles = [SKEmitterNode]()
    
    override init() {
        super.init()
        
        sprite = SKSpriteNode(imageNamed: "PenguinWalk03")
        
        self.size = sprite.size
        
        self.addChild(sprite)
        
        self.zPosition = 10.0
        
        self.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.friction = 0
        self.physicsBody!.categoryBitMask = ColliderType.Penguin.rawValue
        self.physicsBody!.contactTestBitMask = ColliderType.Obstacle.rawValue
        
        self.position.y = -(UIScreen.main.bounds.height/2) + (self.size.height/2) + UIScreen.main.bounds.width*0.0673828125
        
        self.velocity = 1.25 * self.size.height
        self.impulseVelocity = 3 * self.size.height
        
        self.makeTrail()
        
        self.updateScheduler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeTrail() {
        trailParticle = SKEmitterNode(fileNamed: "Snow.sks")
        trailParticle.particlePosition = CGPoint(x: self.position.x,
                                                 y: self.position.y + self.size.height / 2)
        trailParticle.particlePositionRange = CGVector(dx: size.width / 2, dy: -size.height / 2)
        trailParticle.particleSize = CGSize(width: 500, height: 500)
        trailParticle.particleZPosition = 9.0
        
        if let scene = self.scene as? GameScene {
            trailParticle.targetNode = scene
            scene.addChild(trailParticle)
        }
    }
    
    private func stopTrail() {
        trailParticle.isPaused = true
        
        for trail in previousTrailParticles {
            if let scene = self.scene as? GameScene {
                if trail.position.y < (scene.camera?.position.y)! {
                    trail.isHidden = true
                    trail.removeFromParent()
                }
            }
        }
        
        previousTrailParticles.append(self.trailParticle)
    }
    
    public func removeAllTrails() {
        self.removeAllChildren()
        self.removeAllActions()
    }
    
    private func walk() {
        let beginToWalk = SKAction.animate(with: [
            SKTexture(imageNamed: "PenguinWalk01"),
            SKTexture(imageNamed: "PenguinWalk02")
            ], timePerFrame: 0.3)
        let stopTrail = SKAction.run {
            self.stopTrail()
        }
        let walk = SKAction.group([beginToWalk, stopTrail])
        
        let beginToImpulse = SKAction.animate(with: [SKTexture(imageNamed: "PenguinWalk03")], timePerFrame: 1.2)
        let stopImpulse = SKAction.animate(with: [SKTexture(imageNamed: "PenguinWalk04")], timePerFrame: 0.3)
        let impulseSequence = SKAction.sequence([beginToImpulse, stopImpulse])
        
        let impulse = SKAction.run {
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: self.impulseVelocity))
            self.makeTrail()
        }
        let takeImpulse = SKAction.group([impulseSequence, impulse])
        
        let oneStepAnimation = SKAction.sequence([walk, takeImpulse])
        let walkAnimation = SKAction.repeatForever(oneStepAnimation)
        self.sprite.run(walkAnimation, withKey: "animation")
    }
    
    func update(){
        if self.state == .Slide {
            self.walk()
            self.state = .Sliding
        }
        else if self.state == .Sliding {
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
            self.physicsBody!.pinned = true
            self.sprite.removeAction(forKey: "animation")
        }
    }
    
    public func moveLeft(){
        self.physicsBody!.velocity.dx = -self.velocity
        if self.action(forKey: "move") == nil {
            let rotateAction = SKAction.rotate(toAngle: 0.0872665, duration: actionTime)
            self.run(rotateAction, withKey: "move")
            self.trailParticle.emissionAngle = 2.3
        }
    }
    
    public func moveRight(){
        self.physicsBody!.velocity.dx = self.velocity
        if self.action(forKey: "move") == nil {
            let rotateAction = SKAction.rotate(toAngle: -0.0872665, duration: actionTime)
            self.run(rotateAction, withKey: "move")
            self.trailParticle.emissionAngle = 0.7
        }
    }
    
    public func moveCenter(){
//        self.physicsBody!.velocity.dx = 0
        if self.action(forKey: "move") == nil && self.zPosition != 0 {
            let rotateAction = SKAction.rotate(toAngle: 0, duration: actionTime)
            self.run(rotateAction, withKey: "move")
            self.trailParticle.emissionAngle = 1.5
        }
    }
}
