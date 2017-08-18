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
    public var updateDisabled = false
    private var camera: SKCameraNode!
    
    init(with camera: SKCameraNode) {
        super.init()
        
        self.size = UIScreen.main.bounds.size
        
        self.camera = camera
        
        self.marginScore = 90
        
        self.zPosition = 100
        
        //Score
        
        self.score = SKLabelNode(fontNamed: "Helvetica-Bold")
        self.score.fontSize = (size.height*100)/1080
        self.score.text = "0"
        self.score.fontColor = UIColor(red: 1.0/255.0, green: 92.0/255.0, blue: 152.0/255.0, alpha: 1)
        self.score.position.y = (self.size.height*0.5) - (self.score.frame.size.height) - self.marginScore
        self.score.isHidden = true
        
        self.addChild(self.score)
        
        updateScheduler()
    }
    
    func update() {
        if !self.updateDisabled {
            self.updateScore()
        }
    }
    
    func setAsGameOver(){
        
        self.updateDisabled = true
        
        let darkLayer = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: self.size))
        darkLayer.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        darkLayer.position.x -= (self.size.width*0.5)
        darkLayer.position.y -= (self.size.height*0.5)
        darkLayer.zPosition = self.score.zPosition + 1
        self.addChild(darkLayer)
        
        let scoreboard = SKSpriteNode(imageNamed: "Scoreboard")
        scoreboard.position.y = -0.05 * self.size.height
        scoreboard.zPosition = darkLayer.zPosition + 1
        self.addChild(scoreboard)
        
        let difference = abs((self.size.height*0.5) - (scoreboard.size.height*0.5))
        
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position.y = (self.size.height*0.5) - (difference*0.5)
        gameOver.zPosition = 100
        self.addChild(gameOver)
        
        let retryButton = SKLabelNode(fontNamed: "Helvetica-Bold")
        retryButton.fontSize = (size.height*65)/1080
        retryButton.text = "TAP TO RETRY"
        retryButton.fontColor = UIColor(red: 198.0/255.0, green: 234.0/255.0, blue: 249.0/255.0, alpha: 1)
        retryButton.position.y = -(self.size.height*0.5) + (difference*0.5)
        retryButton.zPosition = darkLayer.zPosition + 1
        self.addChild(retryButton)
        
        let increaseScale = SKAction.scale(by: 1.1, duration: 0.5)
        let decreaseScale = SKAction.scale(to: 1, duration: 0.5)
        let animation = SKAction.repeatForever(SKAction.sequence([increaseScale, decreaseScale]))
        retryButton.run(animation)
        
        let userinfo = UserInfoManager.getUserInfo()
        
        if userinfo.distance! >= self.distance {
            
            let highScoreValueLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            highScoreValueLabel.fontSize = (size.height*40)/1080
            highScoreValueLabel.text = String(format: "%.1f m", userinfo.distance)
            highScoreValueLabel.fontColor = self.score.fontColor
            highScoreValueLabel.position.y = (highScoreValueLabel.frame.size.height*0.5)
            highScoreValueLabel.zPosition = 100
            scoreboard.addChild(highScoreValueLabel)
            
            let highScoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            highScoreLabel.fontSize = (size.height*40)/1080
            highScoreLabel.text = "HIGH SCORE"
            highScoreLabel.fontColor = self.score.fontColor
            highScoreLabel.position.y = highScoreValueLabel.position.y + (highScoreValueLabel.frame.size.height) + (highScoreValueLabel.frame.size.height*0.3)
            highScoreLabel.zPosition = 100
            scoreboard.addChild(highScoreLabel)
            
            
            let scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            scoreLabel.fontSize = (size.height*40)/1080
            scoreLabel.text = "SCORE"
            scoreLabel.fontColor = self.score.fontColor
            scoreLabel.position.y = -(scoreLabel.frame.size.height*1.5)
            scoreLabel.zPosition = 100
            scoreboard.addChild(scoreLabel)
            
            let scoreValueLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            scoreValueLabel.fontSize = (size.height*40)/1080
            scoreValueLabel.text = String(format: "%.1f m", self.distance)
            scoreValueLabel.fontColor = self.score.fontColor
            scoreValueLabel.position.y = scoreLabel.position.y - (scoreLabel.frame.size.height) - (scoreLabel.frame.size.height*0.3)
            scoreValueLabel.zPosition = 100
            scoreboard.addChild(scoreValueLabel)
        }
        else {
            
            let highScoreValueLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            highScoreValueLabel.fontSize = (size.height*70)/1080
            highScoreValueLabel.text = String(format: "%.1f m", self.distance)
            highScoreValueLabel.fontColor = self.score.fontColor
            highScoreValueLabel.position.y = -(highScoreValueLabel.frame.size.height)
            highScoreValueLabel.zPosition = 100
            scoreboard.addChild(highScoreValueLabel)
            
            let highScoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
            highScoreLabel.fontSize = (size.height*40)/1080
            highScoreLabel.text = "NEW HIGH SCORE"
            highScoreLabel.fontColor = self.score.fontColor
            highScoreLabel.position.y = highScoreValueLabel.position.y + (highScoreValueLabel.frame.size.height) + (highScoreValueLabel.frame.size.height*0.5)
            highScoreLabel.zPosition = 100
            scoreboard.addChild(highScoreLabel)
        }
        
        UserInfoManager.updateUserInfo(with: self.distance)
    }
    
    private func updateScore(){
        
        let difference = abs(self.camera.position.y - self.lastYPosition)
        
        if difference > (self.size.height*0.01) {
            self.score.isHidden = false
            self.distance += 0.1
            self.lastYPosition = self.camera.position.y
            self.score.text = String(format: "%.1f m", self.distance)
        }
        
        self.score.position.x = (self.size.width*0.5) - (self.score.frame.size.width*0.5) - self.marginScore
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
