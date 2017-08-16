//
//  ControllerDelegate.swift
//  PenguimRush
//
//  Created by Eduardo Fornari on 15/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

protocol ControllerDelegate {
    func moveLeft(with playerIndex: Int) -> Void
    func moveRight(with playerIndex: Int) -> Void
    func moveCenter(with playerIndex: Int) -> Void
}
