//
//  About.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import Firebase

class About {
    var firebaseId: String?
    var order: Int
    var title: String
    var content: String?
    var imageUrl: String?
    var type: String
    
    init(order: Int, title: String, type: String) {
        self.order = order
        self.title = title
        self.type = type
    }
    
    init(snapshot: DataSnapshot) {
        
        self.firebaseId = snapshot.key
        
        let aboutDict = snapshot.value as! NSDictionary
        
        self.order = aboutDict["order"] as! Int
        self.title = aboutDict["title"] as! String
        self.type = aboutDict["type"] as! String
        if let content = aboutDict["content"] as? String {
            self.content = content
        }
        if let image = aboutDict["imageUrl"] as? String {
            self.imageUrl = image
        }
    }
    
}
