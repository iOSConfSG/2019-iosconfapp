//
//  Helpers.swift
//  iosconfsg2019
//
//  Created by Kale on 15/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation

class Helpers {

    class func dictionaryFromPlist(filename: String) -> NSDictionary? {
        
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return dict
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
        
    }
}
