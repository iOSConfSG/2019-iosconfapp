//
//  StyleSheet.swift
//  iosconfsg2019
//
//  Created by bunty.madan on 4/1/20.
//  Copyright © 2020 Vina Melody. All rights reserved.
//

import UIKit
/*
 
 */
class StyleSheet  {
    static let shared = StyleSheet()
    public var theme : StyleSheetProtocol!
    
    private init() {
        if #available(iOS 13.0, *) {
            theme = iOS13AndAbove()
        } else {
            theme = iOS12AndBelow()
        }
    }
}

protocol StyleSheetProtocol {
    var primaryBackgroundColor: UIColor { get }
    var secondaryBackgroundColor: UIColor { get }
    
    var primaryLabelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var tertiaryLabelColor: UIColor { get }
}

/*
 Enables dark mode capability using colors assets.
 */
@available(iOS 13.0, *)
fileprivate class iOS13AndAbove: StyleSheetProtocol {
    var primaryBackgroundColor: UIColor {
        return .systemBackground
    }
    
    var secondaryBackgroundColor: UIColor {
        return .secondarySystemBackground
    }
    
    var primaryLabelColor: UIColor {
        return .purple
    }
    
    var secondaryLabelColor: UIColor {
        return .label
    }
    
    var tertiaryLabelColor: UIColor {
        return .secondaryLabel
    }
}

/*
 Light mode only.
 */
fileprivate class iOS12AndBelow: StyleSheetProtocol {
    var primaryBackgroundColor: UIColor {
        return .white
    }
    
    var secondaryBackgroundColor: UIColor {
        return UIColor.lightGray.withAlphaComponent(0.2)
    }
    
    var primaryLabelColor: UIColor {
        return .purple
    }
    
    var secondaryLabelColor: UIColor {
        return .black
    }
    
    var tertiaryLabelColor: UIColor {
        return .darkGray
    }
}
