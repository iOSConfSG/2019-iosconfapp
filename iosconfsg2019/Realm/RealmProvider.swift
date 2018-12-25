//
//  RealmProvider.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 26/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmProvider {
    
    static let MY_INSTANCE_ADDRESS = "iosconfsg.us1a.cloud.realm.io"
    static let SCHEDULE_REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/twoo19")!
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    
    static let defaultConfig: Realm.Configuration = {
        var config = SyncUser.current?.configuration(realmURL: RealmProvider.SCHEDULE_REALM_URL,
                                                     fullSynchronization: true,
                                                     enableSSLValidation: true,
                                                     urlPrefix: nil)
        
        return config!
    }()
}
