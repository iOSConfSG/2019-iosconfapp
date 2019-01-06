//
//  Speaker.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import FirebaseDatabase


class Speaker {
    var name: String
    var description: String
    var imageFilename: String
    var image: UIImage
    var twitter: String
    var company: String
    var firebaseId: String?
    
    init(snapshot: DataSnapshot) {
        
        self.firebaseId = snapshot.key
        
        let speakerDict = snapshot.value as! NSDictionary
        
        self.name = speakerDict["name"] as! String
        self.description = speakerDict["description"] as! String
        self.imageFilename = speakerDict["imageFilename"] as! String
        self.twitter = speakerDict["twitter"] as! String
        self.company = speakerDict["company"] as! String
        
        let speakerImage = UIImage(named: self.imageFilename)!
        self.image = speakerImage
    }
    
    class func getSpeakerFromFirebase(speakerId: String, block: @escaping (Speaker) -> Void) {
        
        let databaseRef = Database.database().reference()
        let speakersRef = databaseRef.child("speakers")
        let speakerRef = speakersRef.child(speakerId)
        
        speakerRef.observe(.value, with: { (snapshot) in
            let speaker = Speaker(snapshot: snapshot)
            block(speaker)
        })
        
    }
}
