//
//  BaseViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 4/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
}
