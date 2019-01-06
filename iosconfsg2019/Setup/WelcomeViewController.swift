//
//  WelcomeViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 24/12/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import OneSignal

class WelcomeViewController: UIViewController {
    let confImage: UIImageView = {
        let img = UIImage(imageLiteralResourceName: "welcome_icon")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.largeTitleSize, weight: .bold)
        label.text = "iOS Conf SG"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.xLargeSize, weight: .light)
        label.text = "17-19 January 2019"
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let notificationDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.normalSize, weight: .light)
        label.text = "Hi there, please allow us to send you notifications so that we can keep you updated with important announcements. We hope you will enjoy the conference. Thank you!"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let allowNotificationButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Allow Notifications", for: .normal)
        btn.setTitleColor(UIColor.purple, for: .normal)
        btn.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        btn.addTarget(self, action: #selector(requestNotificationPermission), for: .touchUpInside)
        return btn
    }()
    
    let anonymousDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.normalSize, weight: .light)
        label.text = "We've set you a cool nickname as skywalker10920! Don't worry, your feedback remains absolutely anonymous."
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let changeUsernameButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Change Username", for: .normal)
        btn.setTitleColor(UIColor.purple, for: .normal)
        btn.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc private func requestNotificationPermission() {
        
        OneSignal.promptForPushNotifications(userResponse: { (accepted) in
        }, fallbackToSettings: true)
        
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor.purple
        
        view.addSubview(confImage)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(notificationDescriptionLabel)
        view.addSubview(allowNotificationButton)
        view.addSubview(anonymousDescriptionLabel)
        view.addSubview(changeUsernameButton)
        
        confImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confImage.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 80).isActive = true
        confImage.heightAnchor.constraint(equalToConstant: 155).isActive = true
        confImage.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: confImage.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        notificationDescriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12).isActive = true
        notificationDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        notificationDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        allowNotificationButton.topAnchor.constraint(equalTo: notificationDescriptionLabel.bottomAnchor, constant: 12).isActive = true
        allowNotificationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        allowNotificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        allowNotificationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        anonymousDescriptionLabel.topAnchor.constraint(equalTo: allowNotificationButton.bottomAnchor, constant: 12).isActive = true
        anonymousDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        anonymousDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        changeUsernameButton.topAnchor.constraint(equalTo: anonymousDescriptionLabel.bottomAnchor, constant: 12).isActive = true
        changeUsernameButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        changeUsernameButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        changeUsernameButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}
