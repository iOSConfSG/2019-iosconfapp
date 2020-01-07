//
//  WelcomeViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 24/12/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import OneSignal

class WelcomeViewController: BaseViewController {
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
        label.text = "15-18 January 2020"
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
        btn.setTitleColor(StyleSheet.shared.theme.primaryLabelColor, for: .normal)
        btn.backgroundColor = UIColor.init(white: 0.9, alpha: 1)
        btn.addTarget(self, action: #selector(requestNotificationPermission), for: .touchUpInside)
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        updateUserDefaults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func requestNotificationPermission() {
        
        let acceptedAlert = UIAlertController(title: nil, message: "👏🏼 Thank you! You'll now be notified of the latest updates from iOS Conf SG.", preferredStyle: UIAlertController.Style.alert)
        
        let rejectedAlert = UIAlertController(title: nil, message: "😱 You won't see the latest updates from iOS Conf SG for now, but you can enable notifications in Settings.", preferredStyle: UIAlertController.Style.alert)
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                self.logTap(buttonName: "Open Settings")
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        
        let notNowAction = UIAlertAction(title: "Not now", style: .default, handler: { (_) in
            self.logTap(buttonName: "Not now button")
            self.showTabScreen()
        })
        
        rejectedAlert.addAction(settingsAction)
        rejectedAlert.addAction(notNowAction)
        
        OneSignal.promptForPushNotifications(userResponse: { (accepted) in
            if accepted {
                self.logTap(buttonName: "Accepted push notification button")
                self.present(acceptedAlert, animated: true, completion: nil)
                
                let when = DispatchTime.now() + 3.5
                DispatchQueue.main.asyncAfter(deadline: when, execute: {
                    acceptedAlert.dismiss(animated: true, completion: {self.showTabScreen()})
                })
            } else {
                self.present(rejectedAlert, animated: true, completion: nil)
            }
        }, fallbackToSettings: true)
    }
    
    private func showTabScreen() {
        self.dismiss(animated: true, completion: nil)
        let tabViewController = CustomTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tabViewController
    }
    
    private func updateUserDefaults() {
        UserDefaults.standard.set(true, forKey: "sawWelcomeScreen")
    }
    
    private func setupViews() {
        view.backgroundColor = StyleSheet.shared.theme.primaryLabelColor
        
        view.addSubview(confImage)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(notificationDescriptionLabel)
        view.addSubview(allowNotificationButton)
        
        confImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        confImage.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 90).isActive = true
        confImage.heightAnchor.constraint(equalToConstant: 155).isActive = true
        confImage.widthAnchor.constraint(equalToConstant: 155).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: confImage.bottomAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        notificationDescriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 32).isActive = true
        notificationDescriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        notificationDescriptionLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        allowNotificationButton.topAnchor.constraint(equalTo: notificationDescriptionLabel.bottomAnchor, constant: 22).isActive = true
        allowNotificationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        allowNotificationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        allowNotificationButton.heightAnchor.constraint(equalToConstant: 44).isActive = true        
    }

    private func logTap(buttonName: String) {
        let event = TrackingEvent(tap: buttonName, category: "Push Notification Setup")
        AnalyticsManager.shared.log(event: event)
    }
}
