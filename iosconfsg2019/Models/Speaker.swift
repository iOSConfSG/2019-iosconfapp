//
//  Speaker.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 11/1/21.
//  Copyright © 2021 Vina Melody. All rights reserved.
//

import Foundation

struct Speaker: Codable {
    var id: Int
    var name: String
    var shortBio: String?
    var twitter: String?
    var linkedIn: String?
    var company: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortBio = "short_bio"
        case twitter
        case linkedIn = "linkedin"
        case company
        case imageUrl = "image_url"
    }
}
