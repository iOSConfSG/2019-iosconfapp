//
//  StringsExtensions.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 18/12/21.
//  Copyright © 2021 Vina Melody. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        // Specify the bundle to ensure NSLocalizedString also works in unit tests
        let bundle = Bundle(for: AppDelegate.self)
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
}
