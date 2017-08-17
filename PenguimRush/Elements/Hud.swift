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
    private var lastYPosition = CGFloat(0)
    private var distance = Double(0)
    private var marginScore: CGFloat!
    
    override init() {
        super.init()
        
        self.size = UIScreen.main.bounds.size
        
        self.marginScore = size.height*0.05
        
        self.zPosition = 100
        
        self.score = SKLabelNode(fontNamed: "Minecraft")
        self.score.fontSize = (size.height*100)/1080
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
    
    func setAsGameOver(){
        let darkLayer = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: self.size))
        darkLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        darkLayer.position.x -= (self.size.width*0.5)
        darkLayer.position.y -= (self.size.height*0.5)
        darkLayer.zPosition = self.score.zPosition + 1
        self.addChild(darkLayer)
        
        let scoreboard = SKSpriteNode(imageNamed: "Scoreboard")
        scoreboard.zPosition = darkLayer.zPosition + 1
        self.addChild(scoreboard)
        
        let difference = abs((self.size.height*0.5) - (scoreboard.size.height*0.5))
        
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position.y = (self.size.height*0.5) - (difference*0.5)
        gameOver.zPosition = darkLayer.zPosition + 1
        self.addChild(gameOver)
        
        let retryButton = SKSpriteNode(imageNamed: "RetryButton")
        retryButton.position.y = -(self.size.height*0.5) + (difference*0.5)
        retryButton.zPosition = darkLayer.zPosition + 1
        self.addChild(retryButton)
        
        let userinfo = UserInfoManager.getUserInfo()
        
        if userinfo.distance! >= self.distance {
            
            let highScoreValueLabel = SKLabelNode(fontNamed: "Minecraft")
            highScoreValueLabel.fontSize = (size.height*50)/1080
            highScoreValueLabel.text = String(format: "%.1f m", userinfo.distance)
            highScoreValueLabel.fontColor = UIColor.black
            highScoreValueLabel.position.y = (highScoreValueLabel.frame.size.height)
            highScoreValueLabel.zPosition = 100
            scoreboard.addChild(highScoreValueLabel)
            
            let highScoreLabel = SKLabelNode(fontNamed: "Minecraft")
            highScoreLabel.fontSize = (size.height*50)/1080
            highScoreLabel.text = "HIGH SCORE"
            highScoreLabel.fontColor = UIColor.black
            highScoreLabel.position.y = highScoreValueLabel.position.y + (highScoreValueLabel.frame.size.height) + (highScoreValueLabel.frame.size.height*0.5)
            highScoreLabel.zPosition = 100
            scoreboard.addChild(highScoreLabel)
            
            
            let scoreLabel = SKLabelNode(fontNamed: "Minecraft")
            scoreLabel.fontSize = (size.height*80)/1080
            scoreLabel.text = "SCORE"
            scoreLabel.fontColor = UIColor.black
            scoreLabel.position.y = -(scoreLabel.frame.size.height)
            scoreLabel.zPosition = 100
            scoreboard.addChild(scoreLabel)
            
            let scoreValueLabel = SKLabelNode(fontNamed: "Minecraft")
            scoreValueLabel.fontSize = (size.height*80)/1080
            scoreValueLabel.text = String(format: "%.1f m", self.distance)
            scoreValueLabel.fontColor = UIColor.black
            scoreValueLabel.position.y = scoreLabel.position.y - (scoreLabel.frame.size.height) - (scoreLabel.frame.size.height*0.3)
            scoreValueLabel.zPosition = 100
            scoreboard.addChild(scoreValueLabel)
        }
        else {
            
            let highScoreValueLabel = SKLabelNode(fontNamed: "Minecraft")
            highScoreValueLabel.fontSize = (size.height*50)/1080
            highScoreValueLabel.text = String(format: "%.1f m", userinfo.distance)
            highScoreValueLabel.fontColor = UIColor.black
            highScoreValueLabel.position.y = (highScoreValueLabel.frame.size.height*0.5)
            highScoreValueLabel.zPosition = 100
            scoreboard.addChild(highScoreValueLabel)
            
            let highScoreLabel = SKLabelNode(fontNamed: "Minecraft")
            highScoreLabel.fontSize = (size.height*50)/1080
            highScoreLabel.text = "HIGH SCORE"
            highScoreLabel.fontColor = UIColor.black
            highScoreLabel.position.y = highScoreValueLabel.position.y + (highScoreValueLabel.frame.size.height) + (highScoreValueLabel.frame.size.height*0.5)
            highScoreLabel.zPosition = 100
            scoreboard.addChild(highScoreLabel)
            
            
            let scoreLabel = SKLabelNode(fontNamed: "Minecraft")
            scoreLabel.fontSize = (size.height*50)/1080
            scoreLabel.text = "SCORE"
            scoreLabel.fontColor = UIColor.black
            scoreLabel.position.y = highScoreValueLabel.position.y - (highScoreValueLabel.frame.size.height) - (highScoreValueLabel.frame.size.height*0.5)
            scoreLabel.zPosition = 100
            scoreboard.addChild(scoreLabel)
            
            let scoreValueLabel = SKLabelNode(fontNamed: "Minecraft")
            scoreValueLabel.fontSize = (size.height*50)/1080
            scoreValueLabel.text = String(format: "%.1f m", self.distance)
            scoreValueLabel.fontColor = UIColor.black
            scoreValueLabel.position.y = scoreLabel.position.y - (scoreLabel.frame.size.height) - (scoreLabel.frame.size.height*0.5)
            scoreValueLabel.zPosition = 100
            scoreboard.addChild(scoreValueLabel)
        }
        
        
        
        UserInfoManager.updateUserInfo(with: self.distance)
    }
    
    private func updateScore(){
        if let scene = self.parent as? SKScene {
            if let cam = scene.camera {
                
                let difference = abs(cam.position.y - self.lastYPosition)
                
                if difference > (self.size.height*0.01) {
                    self.distance += 0.1
                    self.lastYPosition = cam.position.y
                    if self.distance - Double(Int(self.distance)) > 0 {
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
