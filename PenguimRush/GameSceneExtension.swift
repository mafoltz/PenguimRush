//
//  GameSceneExtension.swift
//  PenguimRush
//
//  Created by Eduardo Fornari on 15/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import Foundation
import SpriteKit
import GameController

extension GameScene {
    func setUpControllerObservers(){
        NotificationCenter.default.addObserver(self, selector: Selector(("connectControllers")), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector(("controllerDisconnected")), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
    }
}
