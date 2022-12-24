//
//  TimelineCellV2.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 12/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import UIKit
import Kingfisher

class TimelineCellV2: UITableViewCell {

    let speakerImage: UIImageView = {
        let face = UIImageView()
        face.image = UIImage(named: "organiser")
        face.translatesAutoresizingMaskIntoConstraints = false
        face.layer.cornerRadius = 64/2
        face.clipsToBounds = true
        face.isUserInteractionEnabled = true
        return face
    }()
    
    let secondSpeakerImage: UIImageView = {
        let face = UIImageView()
        face.translatesAutoresizingMaskIntoConstraints = false
        face.layer.cornerRadius = 64/2
        face.clipsToBounds = true
        face.isUserInteractionEnabled = true
        return face
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .light)
        label.text = "10.00 - 10.30"
        label.numberOfLines = 0
        label.textColor = StyleSheet.shared.theme.tertiaryLabelColor
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Codable in Swift"
        label.font = UIFont.boldSystemFont(ofSize: UIFont.largeSize)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = StyleSheet.shared.theme.primaryLabelColor
        return label
    }()

    let speakerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Organiser"
        label.font = UIFont.systemFont(ofSize: UIFont.normalSize)
        label.numberOfLines = 1
        label.textColor = StyleSheet.shared.theme.secondaryLabelColor
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    func setupCell(talk: Talk) {
        titleLabel.text = talk.title

        if let startAt = talk.startAt, let endAt = talk.endAt {
            var duration = startAt.toConferenceTime()
            duration.append(contentsOf: " - ")
            duration.append(contentsOf: endAt.toConferenceTime())
            self.timeLabel.text = duration
        }
        
        guard let aSpeaker = talk.speakers.first else { return }
        speakerLabel.text = aSpeaker.name
        
        if let imageUrlString = aSpeaker.imageUrl, let imageUrl = URL(string: imageUrlString) {
            speakerImage.kf.setImage(with: imageUrl)
        } else {
            speakerImage.image = UIImage(named: "organiser")
        }
        
        guard talk.speakers.count > 1, let secondSpeaker = talk.speakers.last else {
            if contentView.subviews.contains(secondSpeakerImage) {
                secondSpeakerImage.removeFromSuperview()
            }
            secondSpeakerImage.image = nil
            secondSpeakerImage.isHidden = true
            NSLayoutConstraint.activate([
                speakerImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor)
            ])
            return
        }
        
        // Going this route (add/remove 2ndSpeakerImage from contentView) to ensure cell height is correct
        contentView.addSubview(secondSpeakerImage)
        if let imageUrlString = secondSpeaker.imageUrl, let imageUrl = URL(string: imageUrlString) {
            secondSpeakerImage.kf.setImage(with: imageUrl)
        } else {
            secondSpeakerImage.image = UIImage(named: "organiser")
        }
        secondSpeakerImage.isHidden = false
        
        speakerLabel.text = "\(aSpeaker.name) & \(secondSpeaker.name)"
        
        NSLayoutConstraint.activate([
            secondSpeakerImage.leadingAnchor.constraint(equalTo: speakerImage.leadingAnchor),
            secondSpeakerImage.heightAnchor.constraint(equalTo: speakerImage.heightAnchor),
            secondSpeakerImage.widthAnchor.constraint(equalTo: speakerImage.widthAnchor),
            secondSpeakerImage.topAnchor.constraint(equalTo: speakerImage.bottomAnchor, constant: 8),
            
            speakerImage.bottomAnchor.constraint(equalTo: secondSpeakerImage.topAnchor, constant: -4),
            secondSpeakerImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    private func setupViews() {
        accessoryType = .disclosureIndicator
        separatorInset = .zero

        let marginGuide = contentView.layoutMarginsGuide

        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(speakerLabel)
        contentView.addSubview(speakerImage)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: speakerImage.rightAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            
            speakerImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            speakerImage.heightAnchor.constraint(equalToConstant: 64),
            speakerImage.widthAnchor.constraint(equalToConstant: 64),
            speakerImage.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            
            speakerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            speakerLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            speakerLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: speakerLabel.bottomAnchor, constant: 4),
            timeLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: marginGuide.bottomAnchor),
            
            speakerImage.bottomAnchor.constraint(lessThanOrEqualTo: marginGuide.bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

