//
//  Speaker.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 27/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Speaker: Object, Decodable {

    enum Property: String {
        case key, name, twitter, company, shortBio, imageFilename
    }

    private enum CodingKeys: String, CodingKey {
        case name, twitter, company
        case shortBio = "short_bio"
        case imageFilename = "image_filename"
    }

    dynamic var key: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var twitter: String?
    dynamic var company: String?
    dynamic var shortBio: String?
    dynamic var imageFilename: String = ""

    override static func primaryKey() -> String? {
        return Speaker.Property.key.rawValue
    }

    convenience init(name: String, imageFilename: String) {
        self.init()
        self.name = name
        self.imageFilename = imageFilename
    }

    convenience init(name: String, twitter: String, company: String, shortBio: String, imageFilename: String) {
        self.init()
        self.name = name
        self.twitter = twitter
        self.company = company
        self.shortBio = shortBio
        self.imageFilename = imageFilename
    }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let twitter = try container.decode(String.self, forKey: .twitter)
        let company = try container.decode(String.self, forKey: .company)
        let shortBio = try container.decode(String.self, forKey: .shortBio)
        let imageFilename = try container.decode(String.self, forKey: .imageFilename)
        self.init(name: name, twitter: twitter, company: company, shortBio: shortBio, imageFilename: imageFilename)

    }

    static func all(in realm: Realm) -> Results<Speaker> {
        return realm.objects(Speaker.self)
            .sorted(byKeyPath: Speaker.Property.name.rawValue)
    }

    @discardableResult
    internal func add(to realm: Realm) -> Speaker {
        try! realm.write {
            realm.add(self)
        }
        return self
    }
}
