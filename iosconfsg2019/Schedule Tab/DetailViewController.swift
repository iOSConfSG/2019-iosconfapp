//
//  DetailViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 6/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import AttributedTextView

class DetailViewController: UIViewController {
    
    var talk: Talk? {
        didSet {
            self.talkTitle.text = talk?.title
            
            if let speaker = talk?.speaker {
                self.speakerName.text = speaker.name
                self.speakerCompany.text = speaker.company
                
                let twitter = "@" + speaker.twitter
                self.speakerTwitter.text = twitter
                self.speakerTwitter.attributer = twitter.matchMentions.makeInteract({ (link) in
                    UIApplication.shared.open(URL(string: "https://twitter.com/\(link.replacingOccurrences(of: "@", with: ""))")!, options: [:], completionHandler: { completed in })
                }).setLinkColor(UIColor.purple).size(UIFont.largeSize)
                self.speakerTwitter.setContentOffset(.zero, animated: false)
                self.speakerImage.image = UIImage(imageLiteralResourceName: speaker.imageFilename)
            } else {
                self.speakerName.text = "iOSConfSG Organiser"
                self.speakerCompany.text = ""
                let twitter = "@iosconfsg"
                self.speakerTwitter.text = twitter
                self.speakerTwitter.attributer = twitter.matchMentions.makeInteract({ (link) in
                    UIApplication.shared.open(URL(string: "https://twitter.com/\(link.replacingOccurrences(of: "@", with: ""))")!, options: [:], completionHandler: { completed in })
                }).setLinkColor(UIColor.purple).size(14)
                self.speakerTwitter.setContentOffset(.zero, animated: false)
                self.speakerImage.image = UIImage(imageLiteralResourceName: "welcome_icon")
            }
            
            var duration = talk?.startAt.toConferenceDate()
            duration?.append(contentsOf: ", ")
            duration?.append(contentsOf: talk?.startAt.toConferenceTime() ?? "")
            duration?.append(contentsOf: " - ")
            duration?.append(contentsOf: talk?.endAt.toConferenceTime() ?? "")
            self.talkTime.text = duration
            
            let offset = self.descriptionTextView.contentOffset
            self.descriptionTextView.text = talk?.talkDescription
            OperationQueue.main.addOperation {
                self.descriptionTextView.setContentOffset(offset, animated: false)
            }
        }
    }
    
    let talkTitle: UILabel = {
        let title = UILabel()
        title.text = "Scaling At Large - Lessons learned rewriting Instagram's feed. Plus some very long and super long title to show"
        //title.text = "Scaling At Large"
        title.font = UIFont.boldSystemFont(ofSize: UIFont.xLargeSize)
        title.textColor = UIColor.purple
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
        face.layer.cornerRadius = 64/2
        face.clipsToBounds = true
        face.isUserInteractionEnabled = true
        return face
    }()
    
    let speakerName: UILabel = {
        let name = UILabel()
        name.numberOfLines = 1
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "iOSConfSG"
        name.textColor = UIColor.orange
        return name
    }()
    
    let speakerTwitter: AttributedTextView = {
        let label = AttributedTextView()
        label.isUserInteractionEnabled = true
        label.isEditable = false
        label.isSelectable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        label.bounces = false
        return label
    }()
    
    let speakerCompany: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        tv.isScrollEnabled = true
        tv.showsHorizontalScrollIndicator = true
        tv.showsVerticalScrollIndicator = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = ""
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Feedback", style: .plain, target: self, action: #selector(giveFeedback(_:)))
        
        self.navigationController?.navigationBar.tintColor = UIColor.purple
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
    }
    
    // MARK: - Private methods
    @objc private func giveFeedback(_ sender: Any) {
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.modalPresentationStyle = .popover
        feedbackViewController.preferredContentSize = CGSize(width: 300, height: 300)
        feedbackViewController.talk = self.talk
        
        if let feedbackPopup = feedbackViewController.presentationController as? UIPopoverPresentationController {
            feedbackPopup.sourceView = sender as? UIView
            feedbackPopup.barButtonItem = navigationItem.rightBarButtonItem
            feedbackPopup.permittedArrowDirections = [.down, .up]
            feedbackPopup.delegate = self
            present(feedbackViewController, animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(talkTitle)
        self.view.addSubview(talkTime)
        self.view.addSubview(speakerImage)
        self.view.addSubview(speakerName)
        self.view.addSubview(speakerTwitter)
        self.view.addSubview(speakerCompany)
        self.view.addSubview(descriptionTextView)
        
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
        
        speakerTwitter.topAnchor.constraint(equalTo: speakerName.bottomAnchor, constant: 0).isActive = true
        speakerTwitter.leftAnchor.constraint(equalTo: speakerName.leftAnchor).isActive = true
        speakerTwitter.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        speakerTwitter.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        speakerCompany.topAnchor.constraint(equalTo: speakerTwitter.bottomAnchor, constant: 0).isActive = true
        speakerCompany.leftAnchor.constraint(equalTo: speakerName.leftAnchor).isActive = true
        speakerCompany.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        
        descriptionTextView.leftAnchor.constraint(equalTo: talkTitle.leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: talkTitle.rightAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: speakerImage.bottomAnchor, constant: 22).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: -22).isActive = true
        
        let descriptionStyle = NSMutableParagraphStyle()
        descriptionStyle.lineSpacing = 7
        
        let descriptionAttributes = [
            NSAttributedString.Key.paragraphStyle: descriptionStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.normalSize)
            ] as [NSAttributedString.Key : Any]
        descriptionTextView.attributedText = NSAttributedString(string: descriptionTextView.text, attributes: descriptionAttributes)
        
        let speakerTap = UITapGestureRecognizer(target: self, action: #selector(showSpeakerBio))
        speakerTap.numberOfTapsRequired = 1
        self.speakerImage.addGestureRecognizer(speakerTap)
    }
    
    @objc private func showSpeakerBio() {
        let bioViewController = CustomAlertViewController()
        bioViewController.modalTransitionStyle = .crossDissolve
        bioViewController.modalPresentationStyle = .overCurrentContext
        bioViewController.profileText = self.talk?.speaker?.description
        self.navigationController?.present(bioViewController, animated: true, completion: nil)
        
        
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
