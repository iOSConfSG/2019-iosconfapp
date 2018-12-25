//
//  FeedbackViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    var talkTitle: String = "Scaling At Large - Lessons learned rewriting Instagram's feed. Plus some very long and super long title to show"
    var talk: Talk?
    
    let qualityTitleLabel: UILabel = {
        let title = UILabel()
        title.text = "What do you think of this talk?"
        title.font = UIFont.boldSystemFont(ofSize: UIFont.largeSize)
        title.textColor = UIColor.orange
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let commentTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Type your comment here"
        tv.textColor = UIColor.lightGray
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.returnKeyType = .default
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let neutralButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_neutral")
        let imageInitial = UIImage(imageLiteralResourceName: "face_neutral_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "neutral"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 2
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        return btn
    }()
    
    let grinButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_grin")
        let imageInitial = UIImage(imageLiteralResourceName: "face_grin_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "good"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 4
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        return btn
    }()
    
    let starstruckButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_starstruck")
        let imageInitial = UIImage(imageLiteralResourceName: "face_starstruck_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "excellent"
        btn.adjustsImageWhenHighlighted = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 5
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        return btn
    }()
    
    let smileButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_slightsmile")
        let imageInitial = UIImage(imageLiteralResourceName: "face_slightsmile_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "ok"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 3
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        return btn
    }()
    
    let frowningButton: UIButton = {
        let btn = UIButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_frowning")
        let imageInitial = UIImage(imageLiteralResourceName: "face_frowning_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "poor"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 1
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        return btn
    }()
    
    let sendButton: MyButton = {
        let btn = MyButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.purple
        return btn
    }()
    
    var feedback: Feedback = Feedback(rating: 1, comments: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc private func handleRatingButtonTap(_ sender: UIButton) {
        
        if sender.isSelected {
            return
        }
        let array = [frowningButton, neutralButton, smileButton, grinButton, starstruckButton]
        for btn in array {
            btn.isSelected = false
        }
        let selectedButtons = array.filter({ return $0.isHighlighted })
        
        guard let selectedBtn = selectedButtons.first else {
            return
        }
        selectedBtn.isSelected = true
        self.feedback.rating = selectedBtn.tag
    }
    
    private func setupViews() {
        title = "Feedback for \(talkTitle)"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(qualityTitleLabel)
        self.view.addSubview(frowningButton)
        self.view.addSubview(smileButton)
        self.view.addSubview(neutralButton)
        self.view.addSubview(grinButton)
        self.view.addSubview(starstruckButton)
        self.view.addSubview(commentTextView)
        self.view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            qualityTitleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            qualityTitleLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 12),
            qualityTitleLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 12)
            ])
        
        NSLayoutConstraint.activate([
            frowningButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            frowningButton.topAnchor.constraint(equalTo: qualityTitleLabel.bottomAnchor, constant: 12),
            frowningButton.heightAnchor.constraint(equalToConstant: 40),
            frowningButton.widthAnchor.constraint(equalToConstant: 40),
            neutralButton.leftAnchor.constraint(equalTo: frowningButton.rightAnchor, constant: 4),
            neutralButton.topAnchor.constraint(equalTo: frowningButton.topAnchor),
            neutralButton.heightAnchor.constraint(equalTo: frowningButton.heightAnchor),
            neutralButton.widthAnchor.constraint(equalTo: frowningButton.widthAnchor),
            smileButton.leftAnchor.constraint(equalTo: neutralButton.rightAnchor, constant: 4),
            smileButton.topAnchor.constraint(equalTo: frowningButton.topAnchor),
            smileButton.heightAnchor.constraint(equalTo: frowningButton.heightAnchor),
            smileButton.widthAnchor.constraint(equalTo: frowningButton.widthAnchor),
            grinButton.leftAnchor.constraint(equalTo: smileButton.rightAnchor, constant: 4),
            grinButton.topAnchor.constraint(equalTo: frowningButton.topAnchor),
            grinButton.heightAnchor.constraint(equalTo: frowningButton.heightAnchor),
            grinButton.widthAnchor.constraint(equalTo: frowningButton.widthAnchor),
            starstruckButton.leftAnchor.constraint(equalTo: grinButton.rightAnchor, constant: 4),
            starstruckButton.topAnchor.constraint(equalTo: frowningButton.topAnchor),
            starstruckButton.heightAnchor.constraint(equalTo: frowningButton.heightAnchor),
            starstruckButton.widthAnchor.constraint(equalTo: frowningButton.widthAnchor)
            ])
        
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 44),
            sendButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            sendButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12),
            sendButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -12)
            ])
        
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: frowningButton.bottomAnchor, constant: 12),
            commentTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 12),
            commentTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -12),
            commentTextView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -12)
            ])
        
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.delegate = self
        
        sendButton.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func sendFeedback() {
        
        
        
        if sendButton.isLoading {
            sendButton.loadingIndicator(show: false)
            sendButton.setTitle("Sent!", for: .normal)
        } else {
            sendButton.loadingIndicator(show: true)
            sendButton.setTitle("", for: .normal)
        }
    }    
}

extension FeedbackViewController: UITextViewDelegate {
    
    // Custom text placeholder for textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your news content here"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

