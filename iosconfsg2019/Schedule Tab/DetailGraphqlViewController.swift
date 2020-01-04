//
//  DetailGraphqlViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 21/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import AttributedTextView

class DetailGraphqlViewController: BaseViewController {

    var talk: TalkV2? {
        didSet {
            self.title = talk?.title
            self.talkTitle.text = talk?.title
            self.speakerName.text = talk?.speakerName
            self.speakerCompany.text = talk?.speakerCompany
            let twitter = "@" + (talk?.speakerTwitter ?? "")
            self.speakerTwitter.text = twitter
            self.speakerTwitter.attributer = twitter.matchMentions.makeInteract({ (link) in
                UIApplication.shared.open(URL(string: "https://twitter.com/\(link.replacingOccurrences(of: "@", with: ""))")!, options: [:], completionHandler: { completed in })
            }).setLinkColor(UIColor.purple).size(UIFont.largeSize)
            self.speakerTwitter.setContentOffset(.zero, animated: false)

            if let imageName = talk?.speakerImage {
                self.speakerImage.image = UIImage(imageLiteralResourceName: imageName)
            }
            if let startAt = talk?.startAt, let endAt = talk?.endAt {
                var duration = startAt.toConferenceDate()
                duration.append(contentsOf: ", ")
                duration.append(contentsOf: startAt.toConferenceTime())
                duration.append(contentsOf: " - ")
                duration.append(contentsOf: endAt.toConferenceTime())
                self.talkTime.text = duration
            }
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
        self.view.backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor

        self.navigationController?.navigationBar.tintColor = StyleSheet.shared.theme.primaryLabelColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StyleSheet.shared.theme.primaryLabelColor]

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
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.normalSize),
            NSAttributedString.Key.foregroundColor : StyleSheet.shared.theme.secondaryLabelColor
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
        bioViewController.profileText = self.talk?.speakerBio
        self.navigationController?.present(bioViewController, animated: true, completion: nil)
    }

    private func setupFeedbackButton() {
        if let speakerName = self.talk?.speakerName, speakerName != "Organiser" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Feedback", style: .plain, target: self, action: #selector(giveFeedback(_:)))
        }
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

