//
//  ScheduleViewModel.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 26/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import RealmSwift

protocol ScheduleViewModelDelegate: class {
    func didDownloadRealm(error: Error?, result: Results<Talk>?)
}

class ScheduleViewModel {

    internal var realm: Realm? {
        didSet {
            #if DEBUG
            print("Realm set!")
            #endif
        }
    }

    internal weak var delegate: ScheduleViewModelDelegate?
    
    internal func shouldSetupNickname() -> Bool {
        return UserDefaults().isFirstLaunch
    }
    
    internal func hasNicknameSet() -> String? {
        guard let nickname = UserDefaults().string(forKey: UserDefaultsKeys.nickname.rawValue) else {
            return nil
        }
        return nickname
        
    }

    internal func connect() {

        for user in SyncUser.all {
            print("user \(user.key): \(user.value)")
            user.value.logOut()
        }

        let credentials = SyncCredentials.anonymous()

        SyncUser.logIn(with: credentials, server: RealmProvider.AUTH_URL, timeout: 5.0) { (user, error) in
            if let error = error {
                print("ScheduleViewModel connect error: \(error.localizedDescription)")
            }

            if let user = user {
                #if DEBUG
                print("Realm login ok. User = \(user.identity ?? "unknown user!")")
                #endif

                Realm.asyncOpen(configuration: RealmProvider.defaultConfig, callback: { (realm, error) in
                    if let error = error {
                        #if DEBUG
                        print("Realm asyncopen error: \(error.localizedDescription)")
                        #endif
                        self.delegate?.didDownloadRealm(error: error, result: nil)
                    }
                    if let realm = realm {
                        self.realm = realm
                        self.retrieveSchedule()
                    }
                })
            }
        }
    }

    internal func retrieveSchedule() {
        guard let realm = self.realm else {
            print("ScheduleViewModel error: No realm")
            return
        }

        let schedule = realm.objects(Talk.self)
        self.delegate?.didDownloadRealm(error: nil, result: schedule)
    }
}

fileprivate enum UserDefaultsKeys: String {
    case isFirstLaunch
    case nickname
}
extension UserDefaults {
    
    static func needToSetFirstLaunch() -> Bool {
        return UserDefaults.standard.object(forKey: UserDefaultsKeys.isFirstLaunch.rawValue) == nil
    }
    
    var isFirstLaunch: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstLaunch.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isFirstLaunch.rawValue)
        }
    }
}
