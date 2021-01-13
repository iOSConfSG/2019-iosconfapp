//
//  DetailGraphqlViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 21/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit

import Kingfisher

class DetailGraphqlViewController: BaseViewController {

    var talk: Talk? {
        didSet {
            guard let talk = talk else { return }
            
            self.title = talk.title
            talkTitle.text = talk.title
            
            if let startAt = talk.startAt, let endAt = talk.endAt {
                var duration = startAt.toConferenceDate()
                duration.append(contentsOf: ", ")
                duration.append(contentsOf: startAt.toConferenceTime())
                duration.append(contentsOf: " - ")
                duration.append(contentsOf: endAt.toConferenceTime())
                self.talkTime.text = duration
            }
            let offset = self.descriptionTextView.contentOffset
            self.descriptionTextView.text = talk.talkDescription
            
            guard let firstSpeaker = talk.speakers.first else { return }
            
            speakerName.text = firstSpeaker.name
            speakerCompany.text = firstSpeaker.company
            
            if let firstSpeakerTwitter = firstSpeaker.twitter, !firstSpeakerTwitter.isEmpty {
                let twitter = "@\(firstSpeakerTwitter)"
                speakerTwitter.attributer = twitter.matchMentions.makeInteract({ (link) in
                    UIApplication.shared.open(URL(string: "https://twitter.com/\(link.replacingOccurrences(of: "@", with: ""))")!, options: [:], completionHandler: { completed in })
                }).setLinkColor(StyleSheet.shared.theme.primaryLabelColor).size(UIFont.largeSize)
                speakerTwitter.setContentOffset(.zero, animated: false)
            }
            
            if let imageUrlString = firstSpeaker.imageUrl, let imageUrl = URL(string: imageUrlString) {
                speakerImage.kf.setImage(with: imageUrl)
            } else if let imageFilename = firstSpeaker.imageFilename, let profilePic = UIImage(named: imageFilename) {
                speakerImage.image = profilePic
            }
            
            if talk.speakers.count == 2, let secondSpeaker = talk.speakers.last {
                secondSpeakerName.text = secondSpeaker.name
                secondSpeakerCompany.text = secondSpeaker.company
                
                if let secondTwitter = secondSpeaker.twitter, !secondTwitter.isEmpty {
                    let twitter = "@\(secondTwitter)"
                    secondSpeakerTwitter.attributer = twitter.matchMentions.makeInteract({ (link) in
                        UIApplication.shared.open(URL(string: "https://twitter.com/\(link.replacingOccurrences(of: "@", with: ""))")!, options: [:], completionHandler: { completed in })
                    }).setLinkColor(StyleSheet.shared.theme.primaryLabelColor).size(UIFont.largeSize)
                    secondSpeakerTwitter.setContentOffset(.zero, animated: false)
                }
                
                if let imageUrlString = secondSpeaker.imageUrl, let imageUrl = URL(string: imageUrlString) {
                    secondSpeakerImage.kf.setImage(with: imageUrl)
                } else if let imageFilename = secondSpeaker.imageFilename, let profilePic = UIImage(named: imageFilename) {
                    secondSpeakerImage.image = profilePic
                }
                secondSpeakerContainerView.isHidden = false
                
            } else {
                if view.subviews.contains(secondSpeakerContainerView) {
                    secondSpeakerContainerView.removeFromSuperview()
                    NSLayoutConstraint.activate([
                        descriptionTextView.topAnchor.constraint(equalTo: firstSpeakerContainerView.bottomAnchor, constant: 22),
                    ])
                }
                secondSpeakerContainerView.isHidden = true
            }
            
            OperationQueue.main.addOperation {
                self.descriptionTextView.setContentOffset(offset, animated: false)
            }
        }
    }

    let talkTitle: UILabel = {
        let title = UILabel()
        title.text = "Scaling At Large - Lessons learned rewriting Instagram's feed. Plus some very long and super long title to show"
        title.font = UIFont.boldSystemFont(ofSize: UIFont.xLargeSize)
        title.textColor = StyleSheet.shared.theme.primaryLabelColor
        title.numberOfLines = 5
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    let talkTime: UILabel = {
        let time = UILabel()
        time.text = "10:00 - 10.35"
        time.font = UIFont.systemFont(ofSize: UIFont.smallSize)
        time.textColor = StyleSheet.shared.theme.secondaryLabelColor
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
        name.textColor = StyleSheet.shared.theme.secondaryLabelColor
        return name
    }()

    let speakerTwitter: AttributedTextView = {
        let label = AttributedTextView()
        label.isUserInteractionEnabled = true
        label.isEditable = false
        label.isSelectable = true
        label.textColor = StyleSheet.shared.theme.primaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        label.bounces = false
        label.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        return label
    }()

    let speakerCompany: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = StyleSheet.shared.theme.secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        return label
    }()
    
    let secondSpeakerImage: UIImageView = {
        let face = UIImageView()
        face.image = UIImage(named: "ben")
        face.translatesAutoresizingMaskIntoConstraints = false
        face.layer.cornerRadius = 64/2
        face.clipsToBounds = true
        face.isUserInteractionEnabled = true
        return face
    }()

    let secondSpeakerName: UILabel = {
        let name = UILabel()
        name.numberOfLines = 1
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "iOSConfSG"
        name.textColor = StyleSheet.shared.theme.secondaryLabelColor
        return name
    }()

    let secondSpeakerTwitter: AttributedTextView = {
        let label = AttributedTextView()
        label.isUserInteractionEnabled = true
        label.isEditable = false
        label.isSelectable = true
        label.textColor = StyleSheet.shared.theme.primaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        label.bounces = false
        label.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        return label
    }()

    let secondSpeakerCompany: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = StyleSheet.shared.theme.secondaryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: UIFont.largeSize)
        return label
    }()
    
    let firstSpeakerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let secondSpeakerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    // MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupFeedbackButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
    }

    // MARK: - Private methods
    @objc private func giveFeedback(_ sender: Any) {
        let feedbackViewController = FeedbackViewController()
        feedbackViewController.talk = self.talk
        feedbackViewController.modalPresentationStyle = .popover
        feedbackViewController.preferredContentSize = CGSize(width: 300, height: 300)

        if let feedbackPopup = feedbackViewController.presentationController as? UIPopoverPresentationController {
            feedbackPopup.sourceView = sender as? UIView
            feedbackPopup.barButtonItem = navigationItem.rightBarButtonItem
            feedbackPopup.permittedArrowDirections = [.down, .up]
            feedbackPopup.delegate = self
            present(feedbackViewController, animated: true, completion: {
                self.logTap(talkId: self.talk?.id ?? 0)
            })
        }
    }

    private func setupSecondSpeakerViews() {
        secondSpeakerContainerView.addSubview(secondSpeakerImage)
        secondSpeakerContainerView.addSubview(secondSpeakerName)
        secondSpeakerContainerView.addSubview(secondSpeakerCompany)
        secondSpeakerContainerView.addSubview(secondSpeakerName)
        secondSpeakerContainerView.addSubview(secondSpeakerTwitter)
        
        view.addSubview(secondSpeakerContainerView)
        
        NSLayoutConstraint.activate([
            secondSpeakerContainerView.leftAnchor.constraint(equalTo: firstSpeakerContainerView.leftAnchor),
            secondSpeakerContainerView.rightAnchor.constraint(equalTo: firstSpeakerContainerView.rightAnchor),
            secondSpeakerContainerView.topAnchor.constraint(equalTo: firstSpeakerContainerView.bottomAnchor, constant: 8),
            
            secondSpeakerImage.leftAnchor.constraint(equalTo: secondSpeakerContainerView.leftAnchor),
            secondSpeakerImage.widthAnchor.constraint(equalToConstant: 64),
            secondSpeakerImage.heightAnchor.constraint(equalToConstant: 64),
            secondSpeakerImage.topAnchor.constraint(equalTo: secondSpeakerContainerView.topAnchor),

            secondSpeakerName.leftAnchor.constraint(equalTo: secondSpeakerImage.rightAnchor, constant: 12),
            secondSpeakerName.rightAnchor.constraint(equalTo: secondSpeakerContainerView.rightAnchor),
            secondSpeakerName.topAnchor.constraint(equalTo: secondSpeakerImage.topAnchor),

            secondSpeakerTwitter.topAnchor.constraint(equalTo: secondSpeakerName.bottomAnchor, constant: 2),
            secondSpeakerTwitter.leftAnchor.constraint(equalTo: secondSpeakerName.leftAnchor),
            secondSpeakerTwitter.rightAnchor.constraint(equalTo: secondSpeakerContainerView.rightAnchor),
            secondSpeakerTwitter.heightAnchor.constraint(equalToConstant: 24),

            secondSpeakerCompany.topAnchor.constraint(equalTo: secondSpeakerTwitter.bottomAnchor, constant: 0),
            secondSpeakerCompany.leftAnchor.constraint(equalTo: secondSpeakerName.leftAnchor),
            secondSpeakerCompany.rightAnchor.constraint(equalTo: secondSpeakerContainerView.rightAnchor),
            secondSpeakerCompany.bottomAnchor.constraint(equalTo: secondSpeakerContainerView.bottomAnchor, constant: 0),
            
            descriptionTextView.topAnchor.constraint(equalTo: secondSpeakerContainerView.bottomAnchor, constant: 22),
            descriptionTextView.leftAnchor.constraint(equalTo: talkTitle.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: talkTitle.rightAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
        ])
        
        view.layoutIfNeeded()
    }
    
    private func setupViews() {
        self.view.backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor

        self.navigationController?.navigationBar.tintColor = StyleSheet.shared.theme.primaryLabelColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StyleSheet.shared.theme.primaryLabelColor]

        self.view.addSubview(talkTitle)
        self.view.addSubview(talkTime)
        self.view.addSubview(firstSpeakerContainerView)
        view.addSubview(secondSpeakerContainerView)
        self.view.addSubview(descriptionTextView)
        
        firstSpeakerContainerView.addSubview(speakerImage)
        firstSpeakerContainerView.addSubview(speakerName)
        firstSpeakerContainerView.addSubview(speakerTwitter)
        firstSpeakerContainerView.addSubview(speakerCompany)
        
        secondSpeakerContainerView.addSubview(secondSpeakerImage)
        secondSpeakerContainerView.addSubview(secondSpeakerName)
        secondSpeakerContainerView.addSubview(secondSpeakerCompany)
        secondSpeakerContainerView.addSubview(secondSpeakerName)
        secondSpeakerContainerView.addSubview(secondSpeakerTwitter)
        
        NSLayoutConstraint.activate([
            talkTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            talkTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            talkTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12),
            
            talkTime.topAnchor.constraint(equalTo: talkTitle.bottomAnchor, constant: 8),
            talkTime.leftAnchor.constraint(equalTo: talkTitle.leftAnchor),
            talkTime.rightAnchor.constraint(equalTo: talkTitle.rightAnchor),
            
            firstSpeakerContainerView.topAnchor.constraint(equalTo: talkTime.bottomAnchor, constant: 24),
            firstSpeakerContainerView.leftAnchor.constraint(equalTo: talkTitle.leftAnchor),
            firstSpeakerContainerView.rightAnchor.constraint(equalTo: talkTitle.rightAnchor),
            
            secondSpeakerContainerView.leftAnchor.constraint(equalTo: firstSpeakerContainerView.leftAnchor),
            secondSpeakerContainerView.rightAnchor.constraint(equalTo: firstSpeakerContainerView.rightAnchor),
            secondSpeakerContainerView.topAnchor.constraint(equalTo: firstSpeakerContainerView.bottomAnchor, constant: 8),
            
            descriptionTextView.topAnchor.constraint(equalTo: secondSpeakerContainerView.bottomAnchor, constant: 22),
            descriptionTextView.leftAnchor.constraint(equalTo: talkTitle.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: talkTitle.rightAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -22),
        ])
        
        NSLayoutConstraint.activate([
            speakerImage.leftAnchor.constraint(equalTo: firstSpeakerContainerView.leftAnchor),
            speakerImage.widthAnchor.constraint(equalToConstant: 64),
            speakerImage.heightAnchor.constraint(equalToConstant: 64),
            speakerImage.topAnchor.constraint(equalTo: firstSpeakerContainerView.topAnchor),

            speakerName.leftAnchor.constraint(equalTo: speakerImage.rightAnchor, constant: 12),
            speakerName.rightAnchor.constraint(equalTo: firstSpeakerContainerView.rightAnchor),
            speakerName.topAnchor.constraint(equalTo: speakerImage.topAnchor),

            speakerTwitter.topAnchor.constraint(equalTo: speakerName.bottomAnchor, constant: 2),
            speakerTwitter.leftAnchor.constraint(equalTo: speakerName.leftAnchor),
            speakerTwitter.rightAnchor.constraint(equalTo: firstSpeakerContainerView.rightAnchor),
            speakerTwitter.heightAnchor.constraint(equalToConstant: 24),

            speakerCompany.topAnchor.constraint(equalTo: speakerTwitter.bottomAnchor, constant: 0),
            speakerCompany.leftAnchor.constraint(equalTo: speakerName.leftAnchor),
            speakerCompany.rightAnchor.constraint(equalTo: firstSpeakerContainerView.rightAnchor),
            speakerCompany.bottomAnchor.constraint(equalTo: firstSpeakerContainerView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            secondSpeakerImage.leftAnchor.constraint(equalTo: secondSpeakerContainerView.leftAnchor),
            secondSpeakerImage.widthAnchor.constraint(equalToConstant: 64),
            secondSpeakerImage.heightAnchor.constraint(equalToConstant: 64),
            secondSpeakerImage.topAnchor.constraint(equalTo: secondSpeakerContainerView.topAnchor),

            secondSpeakerName.leftAnchor.constraint(equalTo: secondSpeakerImage.rightAnchor, constant: 12),
            secondSpeakerName.rightAnchor.constraint(equalTo: secondSpeakerContainerView.rightAnchor),
            secondSpeakerName.topAnchor.constraint(equalTo: secondSpeakerImage.topAnchor),

            secondSpeakerTwitter.topAnchor.constraint(equalTo: secondSpeakerName.bottomAnchor, constant: 2),
            secondSpeakerTwitter.leftAnchor.constraint(equalTo: secondSpeakerName.leftAnchor),
            secondSpeakerTwitter.rightAnchor.constraint(equalTo: secondSpeakerContainerView.rightAnchor),
            secondSpeakerTwitter.heightAnchor.constraint(equalToConstant: 24),

            secondSpeakerCompany.topAnchor.constraint(equalTo: secondSpeakerTwitter.bottomAnchor, constant: 0),
            secondSpeakerCompany.leftAnchor.constraint(equalTo: secondSpeakerName.leftAnchor),
            secondSpeakerCompany.rightAnchor.constraint(equalTo: secondSpeakerContainerView.rightAnchor),
            secondSpeakerCompany.bottomAnchor.constraint(equalTo: secondSpeakerContainerView.bottomAnchor, constant: 0),
        ])

        let descriptionStyle = NSMutableParagraphStyle()
        descriptionStyle.lineSpacing = 7

        let descriptionAttributes = [
            NSAttributedString.Key.paragraphStyle: descriptionStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.normalSize),
            NSAttributedString.Key.foregroundColor : StyleSheet.shared.theme.secondaryLabelColor
            ] as [NSAttributedString.Key : Any]
        descriptionTextView.attributedText = NSAttributedString(string: descriptionTextView.text, attributes: descriptionAttributes)

        let speakerTap = UITapGestureRecognizer(target: self, action: #selector(showSpeakerBio))
        speakerTap.numberOfTapsRequired = 1
        self.speakerImage.addGestureRecognizer(speakerTap)
        
        let secondSpeakerTap = UITapGestureRecognizer(target: self, action: #selector(showSecondSpeakerBio))
        secondSpeakerTap.numberOfTapsRequired = 1
        self.secondSpeakerImage.addGestureRecognizer(secondSpeakerTap)
    }

    @objc private func showSpeakerBio() {
        let bioViewController = CustomAlertViewController()
        bioViewController.modalTransitionStyle = .crossDissolve
        bioViewController.modalPresentationStyle = .overCurrentContext
        bioViewController.profileText = self.talk?.speakers.first?.shortBio
        self.navigationController?.present(bioViewController, animated: true, completion: nil)
    }
    
    @objc private func showSecondSpeakerBio() {
        guard let secondSpeaker = talk?.speakers.last else { return }
        
        let bioViewController = CustomAlertViewController()
        bioViewController.modalTransitionStyle = .crossDissolve
        bioViewController.modalPresentationStyle = .overCurrentContext
        bioViewController.profileText = secondSpeaker.shortBio
        self.navigationController?.present(bioViewController, animated: true, completion: nil)
    }

    private func setupFeedbackButton() {
        if let firstSpeaker = talk?.speakers.first, firstSpeaker.name != "Organiser" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Feedback", style: .plain, target: self, action: #selector(giveFeedback(_:)))
        }
    }

    private func logTap(talkId: Int) {
        let event = TrackingEvent(tap: "Feedback Button \(talkId)", category: "Open Feedback")
        AnalyticsManager.shared.log(event: event)
    } 

    override func trackingEvent() -> TrackingEvent? {
        if let talk = self.talk, let trackingEvent = TrackingEvent(screenView: self, screenName: "Detail - \(talk.title)") {
            return trackingEvent
        }
        return nil
    }
}

extension DetailGraphqlViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

