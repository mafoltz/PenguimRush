//
//  UserDefaultsManager.swift
//  nanoChallenge3
//
//  Created by Douglas Gehring on 26/06/17.
//
//

import UIKit
import CloudKit

struct UserInfo {
    var distance: Double!
    
    init(with distance: Double) {
        self.distance = distance
    }
}

class UserInfoManager {
    
    static func updateUserInfo(with distance: Double) {
        updateUserDefaults(with: distance)
    }
    
    static func resetUserInfo(){
        updateUserDefaults(with: 0)
    }
    
    static func updateUserDefaults(with distance: Double){
        let userDefault = UserDefaults.standard
        
        userDefault.set(distance, forKey: "BestDistance")
    }
    
    static func getUserInfo() -> UserInfo {
        
        let userDefault = UserDefaults.standard
        
        if !(userDefault.bool(forKey: "BestDistance")) {
            updateUserDefaults(with: 0)
        }
        
        let distance = userDefault.double(forKey: "BestDistance")
        
        return UserInfo(with: distance)
    }
    
}
