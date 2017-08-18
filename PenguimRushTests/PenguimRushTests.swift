//
//  PenguimRushTests.swift
//  PenguimRushTests
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import XCTest
import SpriteKit
@testable import PenguinRush

class PenguimRushTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGameScene() {
        let gameViewController = GameViewController()
        gameViewController.view = SKView()
        gameViewController.viewDidLoad()
        gameViewController.didReceiveMemoryWarning()
        
        let gameScene = GameScene()
        gameScene.didMove(to: gameViewController.view as! SKView)
        gameScene.didBegin(SKPhysicsContact())
        gameScene.controllerDisconnected()
        gameScene.resetScene()
        gameScene.connectControllers()
        gameScene.move(with: 2.1, and: 0)
        
        UserInfoManager.updateUserInfo(with: 123.4)
        UserInfoManager.resetUserInfo()
    }
    
    func testPenguin() {
        let penguin = Penguin()
        penguin.moveCenter()
        penguin.moveLeft()
        penguin.moveRight()
        penguin.update()
        penguin.updateScale(forDeviceWidthPercentage: 0.3)
        penguin.updateScale(forDeviceHeightPercentage: 0.2)
    }
}
