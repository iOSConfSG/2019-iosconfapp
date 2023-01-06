//
//  FeedbackViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController {
    
    var selectedButton: MyButton?
    var talk: Talk?
    
    let qualityTitleLabel: UILabel = {
        let title = UILabel()
        title.text = "What do you think of this talk?"
        title.font = UIFont.boldSystemFont(ofSize: UIFont.largeSize)
        title.textColor = StyleSheet.shared.theme.secondaryLabelColor
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
    
    let errorLabel: UILabel = {
        let title = UILabel()
        title.text = "Something went wrong, try again."
        title.textColor = UIColor.red
        title.translatesAutoresizingMaskIntoConstraints = false
        title.isHidden = true
        return title
    }()
    
    let neutralButton: MyButton = {
        let btn = MyButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_neutral")
        let imageInitial = UIImage(imageLiteralResourceName: "face_neutral_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "neutral"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        btn.feeling = Feedback.Feeling.neutral
        return btn
    }()
    
    let grinButton: MyButton = {
        let btn = MyButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_grin")
        let imageInitial = UIImage(imageLiteralResourceName: "face_grin_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "good"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        btn.feeling = Feedback.Feeling.grin
        return btn
    }()
    
    let starstruckButton: MyButton = {
        let btn = MyButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_starstruck")
        let imageInitial = UIImage(imageLiteralResourceName: "face_starstruck_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "excellent"
        btn.adjustsImageWhenHighlighted = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        btn.feeling = Feedback.Feeling.starstruck
        return btn
    }()
    
    let smileButton: MyButton = {
        let btn = MyButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_slightsmile")
        let imageInitial = UIImage(imageLiteralResourceName: "face_slightsmile_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "ok"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        btn.feeling = Feedback.Feeling.smile
        return btn
    }()
    
    let frowningButton: MyButton = {
        let btn = MyButton(type: .custom)
        let imageSelected = UIImage(imageLiteralResourceName: "face_frowning")
        let imageInitial = UIImage(imageLiteralResourceName: "face_frowning_dark")
        btn.setImage(imageInitial, for: .normal)
        btn.setImage(imageSelected, for: .highlighted)
        btn.setImage(imageSelected, for: .selected)
        btn.accessibilityIdentifier = "poor"
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleRatingButtonTap), for: .touchUpInside)
        btn.feeling = Feedback.Feeling.frowning
        return btn
    }()
    
    let sendButton: MyButton = {
        let btn = MyButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = StyleSheet.shared.theme.primaryLabelColor
        return btn
    }()
    
    let parentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor
        return scrollView
    }()

    lazy var viewModel: FeedbackViewModel = FeedbackViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handleKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sendButton.loadingIndicator(show: false)
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
        self.selectedButton = selectedBtn
    }
    
    private func setupViews() {
        self.view.backgroundColor = StyleSheet.shared.theme.primaryBackgroundColor
        self.view.addSubview(parentScrollView)
        
        self.parentScrollView.addSubview(qualityTitleLabel)
        self.parentScrollView.addSubview(frowningButton)
        self.parentScrollView.addSubview(smileButton)
        self.parentScrollView.addSubview(neutralButton)
        self.parentScrollView.addSubview(grinButton)
        self.parentScrollView.addSubview(starstruckButton)
        self.parentScrollView.addSubview(commentTextView)
        self.parentScrollView.addSubview(sendButton)
        self.parentScrollView.addSubview(errorLabel)
        
        parentScrollView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: parentScrollView, attribute: $0, relatedBy: .equal, toItem: parentScrollView.superview, attribute: $0, multiplier: 1, constant: 0)
        })
        
        NSLayoutConstraint.activate([
            qualityTitleLabel.leftAnchor.constraint(equalTo: self.parentScrollView.leftAnchor, constant: 12),
            qualityTitleLabel.rightAnchor.constraint(equalTo: self.parentScrollView.rightAnchor, constant: 12),
            qualityTitleLabel.topAnchor.constraint(equalTo: self.parentScrollView.topAnchor, constant: 24),
            ])
        
        NSLayoutConstraint.activate([
            frowningButton.leftAnchor.constraint(equalTo: self.parentScrollView.leftAnchor, constant: 12),
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
            sendButton.leftAnchor.constraint(equalTo: self.parentScrollView.leftAnchor, constant: 12),
            sendButton.rightAnchor.constraint(equalTo: self.parentScrollView.rightAnchor, constant: -12),
            sendButton.bottomAnchor.constraint(equalTo: self.parentScrollView.bottomAnchor, constant: -12)
            ])

        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: frowningButton.bottomAnchor, constant: 12),
            commentTextView.leftAnchor.constraint(equalTo: self.parentScrollView.leftAnchor, constant: 12),
            commentTextView.rightAnchor.constraint(equalTo: self.parentScrollView.rightAnchor, constant: -12),
            commentTextView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -12),
            commentTextView.heightAnchor.constraint(equalToConstant: 90),
            errorLabel.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 8),
            errorLabel.leftAnchor.constraint(equalTo: commentTextView.leftAnchor),
            errorLabel.rightAnchor.constraint(equalTo: commentTextView.rightAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -12)
            ])

        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.delegate = self

        sendButton.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.parentScrollView.addGestureRecognizer(tapGesture)
    }
    
    private func handleKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil) { (notification) in
            self.parentScrollView.scrollToView(view: self.commentTextView, animated: true)
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func sendFeedback() {
        sendButton.loadingIndicator(show: true)
        self.errorLabel.isHidden = true
        guard let talk = self.talk,
            let selectedButton = self.selectedButton,
            let feeling = selectedButton.feeling else {
            #if DEBUG
            print("Empty feedback")
            #endif
            sendButton.loadingIndicator(show: false)
            return
        }
        viewModel.submitFeedback(for: talk, feeling: feeling, comments: self.commentTextView.text, completionHandler: { [weak self] result in
            switch result {
            case .success:
                self?.sendButton.loadingIndicator(show: false)
                self?.sendButton.setTitle("Thanks, feedback sent!", for: .normal)

                let when = DispatchTime.now() + 1.53
                DispatchQueue.main.asyncAfter(deadline: when, execute: {
                    self?.dismiss(animated: true, completion: nil)
                })
            case .failure:
                self?.sendButton.loadingIndicator(show: false)
                self?.errorLabel.isHidden = false
                self?.sendButton.setTitle("Send", for: .normal)
            }
        })
    }
}

extension FeedbackViewController: UITextViewDelegate {
    
    // Custom text placeholder for textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = StyleSheet.shared.theme.tertiaryLabelColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your news content here"
            textView.textColor = StyleSheet.shared.theme.tertiaryLabelColor
        }
    }
    
}

private extension UIScrollView {
    func scrollToView(view: UIView, animated: Bool) {
        if view.superview == self {
            self.scrollRectToVisible(view.frame, animated: animated)
        }
    }
}
