//
//  CustomAlertViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 13/1/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import AttributedTextView

class CustomAlertViewController: BaseViewController {
    
    let descriptionTextView: AttributedTextView = {
        let tv = AttributedTextView()
        tv.isEditable = false
        tv.isScrollEnabled = true
        tv.showsHorizontalScrollIndicator = true
        tv.showsVerticalScrollIndicator = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Some description"
        tv.backgroundColor = UIColor.purple
        tv.isSelectable = false
        tv.layer.cornerRadius = 10
        tv.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return tv
    }()
    
    var profileText: String? {
        didSet {
            descriptionTextView.attributer = profileText?.font(UIFont.systemFont(ofSize: UIFont.normalSize)).color(UIColor.white).paragraphSpacing(2.0).matchLinks ?? Attributer("")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        self.view.addSubview(descriptionTextView)
        let width = self.view.frame.width - 100

        descriptionTextView.widthAnchor.constraint(equalToConstant: width).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 228).isActive = true
        descriptionTextView.centerYAnchor.constraint(equalTo: self.view?.centerYAnchor ?? NSLayoutYAxisAnchor()).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: self.view?.centerXAnchor ?? NSLayoutXAxisAnchor()).isActive = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSelf)))
        
    }
    
    @objc private func hideSelf() {
        UIView.animate(withDuration: 0.7, delay: 0.3, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.view.alpha = 0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}

