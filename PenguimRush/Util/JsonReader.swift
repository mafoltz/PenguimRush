//
//  JsonReader.swift
//  PenguimRush
//
//  Created by Marcelo Andrighetto Foltz on 14/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class JsonReader: Any {
    
    // MARK: - Methods
    
    static func openJson(named filename: String) -> [[[String: Any]]]? {
        do {
            if let file = Bundle.main.url(forResource: filename, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonContent = json as? [[[String: Any]]] {
                    return jsonContent
                }
                else {
                    print("Json is invalid")
                }
            } else {
                print("Json file was not found")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func loadEnvironment(from json: [[[String: Any]]], index: Int) -> Environment? {
        return Environment(from: json, index: index)
    }
}
