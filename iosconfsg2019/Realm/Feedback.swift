//
//  Feedback.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 27/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Feedback: Object {

    enum Property: String {
        case key, rating, comments
    }

    private enum CodingKeys: String, CodingKey {
        case rating, comments
    }

    dynamic var key: String = UUID().uuidString
    dynamic var rating: Int = 0
    dynamic var comments: String = ""
    dynamic var talk: Talk?

    override static func primaryKey() -> String? {
        return Feedback.Property.key.rawValue
    }

    convenience init(rating: Int, comments: String) {
        self.init()
        self.rating = rating
        self.comments = comments
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rating = try container.decode(Int.self, forKey: .rating)
        let comments = try container.decode(String.self, forKey: .comments)
        self.init(rating: rating, comments: comments)
    }

    @discardableResult
    internal func add(to realm: Realm) -> Feedback {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch let error {
            print("Realm writing feedback error: \(error.localizedDescription)")
        }
        return self
    }
}
