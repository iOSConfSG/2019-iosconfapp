//
//  FeedbackViewModel.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 22/12/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import RealmSwift

protocol FeedbackViewModelDelegate: class {
    func didSendFeedback(error: Error?, result: Results<Feedback>?)
}

class FeedbackVieModel {
    
    internal var realm: Realm? {
        didSet {
            #if DEBUG
            print("FeedbackVieModel Realm set!")
            #endif
        }
    }
    
    internal weak var delegate: FeedbackViewModelDelegate?
    
    internal func sendFeedback(feedback: Feedback) {
        guard let realm = self.realm else {
            #if DEBUG
            print("FeedbackViewModel realm not set")
            #endif
            return
        }
        feedback.add(to: realm)
        
    }
}
