//
//  Controller.swift
//  PenguimRush
//
//  Created by Eduardo Fornari on 15/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import GameController
import SpriteKit

class Controller: SKNode, Updatable {
    
    private var contoller: GCController!
    public var delegate: ControllerDelegate!
    public var playerIndex: Int!
    
    init(with controller: GCController) {
        super.init()
        self.contoller = controller
        self.playerIndex =  self.contoller.playerIndex.hashValue
        self.updateScheduler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        self.delegate.move(with: self.contoller.motion!.gravity.x, and: self.playerIndex)
    }
}
