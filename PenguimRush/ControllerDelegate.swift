//
//  ControllerDelegate.swift
//  PenguimRush
//
//  Created by Eduardo Fornari on 15/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

protocol ControllerDelegate {
    
    func move(with xGravity: Double, and playerIndex: Int)
}
