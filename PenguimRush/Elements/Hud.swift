//
//  Hud.swift
//  Rocket
//
//  Created by Eduardo Fornari on 06/08/17.
//  Copyright © 2017 Eduardo Fornari. All rights reserved.
//

import SpriteKit

class Hud: SKNode, Updatable {
    
    private var size: CGSize!
    
    private var score: SKLabelNode!
    
    private var distance = CGFloat(0)
    
    private var marginScore: CGFloat!
    
    override init() {
        super.init()
        
        self.size = UIScreen.main.bounds.size
        
        self.marginScore = size.height*0.05
        
        self.zPosition = 100
        
        self.score = SKLabelNode(fontNamed: "Arial-BoldMT")
        self.score.fontSize = (size.height*100)/1024
        self.score.text = "0 m"
        self.score.fontColor = UIColor(red: 255.0/255.0, green: 194.0/255.0, blue: 26.0/255.0, alpha: 1)
        self.score.position.y = (self.size.height*0.5) - (self.score.frame.size.height) - self.marginScore
        self.updateScore()
        
        self.addChild(self.score)
        
        updateScheduler()
        
    }
    
    func update() {
        self.updateScore()
    }
    
    private func updateScore(){
        if let scene = self.parent as? SKScene {
            if let cam = scene.camera {
                
                let newDistance = cam.position.y/(self.size.height*0.95)
                
                if newDistance > self.distance {
                    self.distance = newDistance
                    if self.distance - CGFloat(Int(self.distance)) > 0 {
                        self.score.text = String(format: "%.1f m", self.distance)
                    }
                    else{
                        self.score.text = String(format: "%.0f m", self.distance)
                    }
                }
                
            }
        }
        
        self.score.position.x = (self.size.width*0.5) - (self.score.frame.size.width*0.5) - self.marginScore
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
