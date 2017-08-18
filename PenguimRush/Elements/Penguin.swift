//
//  Penguin.swift
//  PenguinRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameController

class Penguin: SKNode, Updatable, Scaleable {
    
    public enum State {
        case Stopped
        case Slide
        case Sliding
        case Crashed
    }
    
    public enum Direction {
        case left
        case right
    }
    
    var size: CGSize = CGSize(width: 0, height: 0)
    private let actionTime = TimeInterval(0.15)
    public var state = State.Stopped
    private var velocity: CGFloat!
    private var impulseVelocity: CGFloat!
    private var sprite: SKSpriteNode!
    private var footprintsParticles = [SKEmitterNode]()
    
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
        
        self.updateScheduler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeFootprint(direction: Direction) {
        let footprintParticle = SKEmitterNode(fileNamed: "Trail.sks")!
        footprintParticle.particleZPosition = 0.1
        
        let footsDistance: CGFloat = 15
        if direction == .left {
            footprintParticle.particlePosition = CGPoint(x: self.position.x - footsDistance,
                                                         y: self.position.y - self.size.height / 3)
        }
        else {
            footprintParticle.particlePosition = CGPoint(x: self.position.x + footsDistance,
                                                         y: self.position.y - self.size.height / 3)
        }
        
        if let scene = self.scene as? GameScene {
            footprintParticle.targetNode = scene
            scene.addChild(footprintParticle)
        }
        
        footprintsParticles.append(footprintParticle)
    }
    
    private func removeUnusedFootprints() {
        for footprintParticle in footprintsParticles {
            if let scene = self.scene as? GameScene {
                if footprintParticle.position.y < (scene.camera?.position.y)! {
                    footprintParticle.removeAllActions()
                    footprintParticle.removeFromParent()
                }
            }
        }
    }
    
    private func walk() {
        self.removeUnusedFootprints()
        
        let makeLeftFootprint = SKAction.run {
            self.makeFootprint(direction: .left)
        }
        let makeRightFootprint = SKAction.run {
            self.makeFootprint(direction: .right)
        }
        
        let firstStep = SKAction.group([SKAction.animate(with: [SKTexture(imageNamed: "PenguinWalk01")], timePerFrame: 0.3), makeRightFootprint])
        let secondStep = SKAction.group([SKAction.animate(with: [SKTexture(imageNamed: "PenguinWalk02")], timePerFrame: 0.3), makeLeftFootprint])
        let walk = SKAction.sequence([firstStep, secondStep])
        
        let beginToImpulse = SKAction.group([SKAction.animate(with: [SKTexture(imageNamed: "PenguinWalk03")], timePerFrame: 1.2), makeRightFootprint])
        let stopImpulse = SKAction.group([SKAction.animate(with: [SKTexture(imageNamed: "PenguinWalk04")], timePerFrame: 0.3), makeLeftFootprint])
        let impulseSequence = SKAction.sequence([beginToImpulse, stopImpulse])
        
        let impulse = SKAction.run {
            self.physicsBody!.applyImpulse(CGVector(dx: 0, dy: self.impulseVelocity))
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
            print("Penguin update slide")
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
        }
    }
    
    public func moveRight(){
        self.physicsBody!.velocity.dx = self.velocity
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
