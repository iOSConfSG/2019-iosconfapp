//
//  UIButtonExtensions.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class MyButton: UIButton {
    
    public var feeling: Feedback.Feeling?
    
    internal var isLoading: Bool = false
    
    func loadingIndicator(show: Bool) {
        if show {
            setTitle("", for: .normal)
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.color = UIColor.white
            self.addSubview(indicator)
            indicator.startAnimating()
            isLoading = true
        } else {
            for view in self.subviews {
                if let indicator = view as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                    isLoading = false
                }
            }
        }
    }
}
