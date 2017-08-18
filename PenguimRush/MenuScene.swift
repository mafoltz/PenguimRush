//
//  MneuScene.swift
//  PenguinRush
//
//  Created by Eduardo Fornari on 17/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    private var blizzardParticle: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.backgroundColor = UIColor(red: 224/255, green: 236/255, blue: 239/255, alpha: 1.0)
        
        //Title
        
        let title = SKSpriteNode(imageNamed: "Title")
        title.zPosition = 1000
        title.position.y = (self.size.height*0.25)
        addChild(title)
        
        //HandController
        
        let handController = SKSpriteNode(imageNamed: "CenterController")
        handController.xScale = 0.5
        handController.yScale = 0.5
        handController.zPosition = 1000
        
        let moveHandControler = SKAction.animate(with: [
            SKTexture(imageNamed: "RightController"),
            SKTexture(imageNamed: "CenterController"),
            SKTexture(imageNamed: "LeftController"),
            SKTexture(imageNamed: "CenterController")
            ], timePerFrame: 0.5)
        let forever = SKAction.repeatForever(moveHandControler)
        handController.run(forever)
        self.addChild(handController)
        
        //Scenary
        
        let scenaryRight = SKSpriteNode(imageNamed: "ScenaryRight")
        scenaryRight.position.x = (self.size.width*0.5) - (scenaryRight.size.width*0.5)
        self.addChild(scenaryRight)
        
        let scenaryLeft = SKSpriteNode(imageNamed: "ScenaryLeft")
        scenaryLeft.position.x = -(self.size.width*0.5) + (scenaryLeft.size.width*0.5)
        self.addChild(scenaryLeft)
        
        let marginDistance: CGFloat = 300.0
        
        let pineGroupRight = SKSpriteNode(imageNamed: "PineGroupRight")
        pineGroupRight.position.x = (self.size.width*0.5) - (pineGroupRight.size.width*0.5) - marginDistance
        pineGroupRight.zPosition = scenaryRight.zPosition + 0.1
        self.addChild(pineGroupRight)
        
        let pineGroupLeft = SKSpriteNode(imageNamed: "PineGroupLeft")
        pineGroupLeft.position.x = -(self.size.width*0.5) + (pineGroupLeft.size.width*0.5) + marginDistance
        pineGroupLeft.zPosition = scenaryLeft.zPosition + 0.1
        self.addChild(pineGroupLeft)
        
        //Blizzard
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for child in self.children {
            for childOfChild in child.children {
                childOfChild.removeAllActions()
                childOfChild.removeFromParent()
            }
            child.removeAllActions()
            child.removeFromParent()
        }
        
        self.blizzardParticle.removeAllActions()
        self.blizzardParticle.removeFromParent()
        
        self.removeAllActions()
        
        let scene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
    }
}
