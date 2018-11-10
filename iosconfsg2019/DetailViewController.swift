//
//  DetailViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let talkTitle: UILabel = {
        let title = UILabel()
        title.text = "Scaling At Large - Lessons learned rewriting Instagram's feed. Plus some very long and super long title to show"
        //title.text = "Scaling At Large"
        title.font = UIFont.boldSystemFont(ofSize: UIFont.xLargeSize)
        title.textColor = UIColor.orange
        title.numberOfLines = 5
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let talkTime: UILabel = {
        let time = UILabel()
        time.text = "10:00 - 10.35"
        time.font = UIFont.systemFont(ofSize: UIFont.smallSize)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    let speakerImage: UIImageView = {
        let face = UIImageView()
        face.image = UIImage(named: "ben")
        face.translatesAutoresizingMaskIntoConstraints = false
        return face
    }()
    
    let speakerName: UILabel = {
        let name = UILabel()
        name.numberOfLines = 3
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "iOSConfSG\n@iosconfsg\nwww.iosconf.sg"
        return name
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        tv.isScrollEnabled = true
        tv.showsHorizontalScrollIndicator = true
        tv.showsVerticalScrollIndicator = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Earlier this year, Instagram released a rewritten newsfeed on iOS. When rebuilding its feed, the team undertook a huge refactor of its most-used feature, all while other teams were actively working on it. From this refactor, they learned a lot about how to build a highly-performant and stable feed, and through this work built a new open source project called IGListKit. Come learn about how and why the Instagram team took on rewriting their iOS feed from the bottom up, see what it takes to ship a successful refactor, and learn about their new open source project being released."
        return tv
    }()
    
    let feedbackButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Leave Feedback", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        return btn
    }()
    
    // MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        feedbackButton.addTarget(self, action: #selector(handleFeedback), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Feedback", style: .plain, target: self, action: #selector(giveFeedback(_:)))       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
    }
    
    @objc private func giveFeedback(_ sender: Any) {
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.modalPresentationStyle = .popover
        feedbackViewController.preferredContentSize = CGSize(width: 300, height: 300)
        
        if let feedbackPopup = feedbackViewController.presentationController as? UIPopoverPresentationController {
            feedbackPopup.sourceView = sender as? UIView
            feedbackPopup.barButtonItem = navigationItem.rightBarButtonItem
            feedbackPopup.permittedArrowDirections = [.down, .up]
            feedbackPopup.delegate = self
            present(feedbackViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func handleFeedback() {
        
        
    }
    
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(talkTitle)
        self.view.addSubview(talkTime)
        self.view.addSubview(speakerImage)
        self.view.addSubview(speakerName)
        self.view.addSubview(descriptionTextView)
        self.view.addSubview(feedbackButton)
        
        talkTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12).isActive = true
        talkTitle.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 12).isActive = true
        talkTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12).isActive = true
        
        talkTime.topAnchor.constraint(equalTo: talkTitle.bottomAnchor, constant: 8).isActive = true
        talkTime.leftAnchor.constraint(equalTo: talkTitle.leftAnchor).isActive = true
        talkTime.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        
        speakerImage.leftAnchor.constraint(equalTo: talkTitle.leftAnchor).isActive = true
        speakerImage.widthAnchor.constraint(equalToConstant: 64).isActive = true
        speakerImage.heightAnchor.constraint(equalToConstant: 64).isActive = true
        speakerImage.topAnchor.constraint(equalTo: talkTime.bottomAnchor, constant: 24).isActive = true
        
        speakerName.leftAnchor.constraint(equalTo: speakerImage.rightAnchor, constant: 12).isActive = true
        speakerName.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        speakerName.topAnchor.constraint(equalTo: speakerImage.topAnchor).isActive = true
        
        descriptionTextView.leftAnchor.constraint(equalTo: talkTitle.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: speakerImage.bottomAnchor, constant: 22).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        feedbackButton.leftAnchor.constraint(equalTo: talkTitle.leftAnchor).isActive = true
        feedbackButton.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        feedbackButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 12).isActive = true
        feedbackButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        let descriptionStyle = NSMutableParagraphStyle()
        descriptionStyle.lineSpacing = 7
        
        let descriptionAttributes = [
            NSAttributedString.Key.paragraphStyle: descriptionStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.normalSize)
            ] as [NSAttributedString.Key : Any]
        descriptionTextView.attributedText = NSAttributedString(string: descriptionTextView.text, attributes: descriptionAttributes)
        
        
        let speakerText = speakerName.text!
        let speakerInfoAttrText = NSMutableAttributedString(string: speakerText)
        let twitterRange = (speakerText as NSString).range(of: "@iosconfsg")
        speakerInfoAttrText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: twitterRange)
        let urlRange = (speakerText as NSString).range(of: "www.iosconf.sg")
        speakerInfoAttrText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: urlRange)
        speakerName.attributedText = speakerInfoAttrText
        
    }
}

extension DetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
